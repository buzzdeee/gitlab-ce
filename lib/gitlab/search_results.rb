# rubocop:disable GitlabSecurity/PublicSend

module Gitlab
  class SearchResults
    class FoundBlob
      attr_reader :id, :filename, :basename, :ref, :startline, :data

      def initialize(opts = {})
        @id = opts.fetch(:id, nil)
        @filename = opts.fetch(:filename, nil)
        @basename = opts.fetch(:basename, nil)
        @ref = opts.fetch(:ref, nil)
        @startline = opts.fetch(:startline, nil)
        @data = opts.fetch(:data, nil)
      end

      def path
        filename
      end

      def no_highlighting?
        false
      end
    end

    COUNTABLE_COLLECTIONS = [:projects, :issues, :merge_requests, :milestones].freeze

    attr_reader :current_user, :query

    # Limit search results by passed projects
    # It allows us to search only for projects user has access to
    attr_reader :limit_projects

    # Whether a custom filter is used to restrict scope of projects.
    # If the default filter (which lists all projects user has access to)
    # is used, we can skip it when filtering merge requests and optimize the
    # query
    attr_reader :default_project_filter

    def initialize(current_user, limit_projects, query, default_project_filter: false)
      @current_user = current_user
      @limit_projects = limit_projects || Project.all
      @query = query
      @default_project_filter = default_project_filter
    end

    def objects(scope, page = nil)
      case scope
      when 'projects'
        projects.page(page).per(per_page)
      when 'issues'
        issues.page(page).per(per_page)
      when 'merge_requests'
        merge_requests.page(page).per(per_page)
      when 'milestones'
        milestones.page(page).per(per_page)
      else
        Kaminari.paginate_array([]).page(page).per(per_page)
      end
    end

    def countable_collections
      COUNTABLE_COLLECTIONS
    end

    def count(collection, limit: nil)
      unless countable_collections.include?(collection)
        raise ArgumentError, "unknown countable collection '#{collection}'"
      end

      key = limit || :all
      @counts ||= countable_collections.map {|i| [i, {}]}.to_h
      @counts[collection][key] ||= limit ? limited_count(collection, limit) : send(collection).count
    end

    def single_commit_result?
      false
    end

    private

    def limited_count(collection, limit)
      if collection == :issues
        issues_limited_count(limit)
      else
        send(collection).limit(limit).count
      end
    end

    # By default getting limited count (e.g. 1000+) is fast on issuable
    # collections except for issues, where filtering both not confidential
    # and confidential issues user has access to, is too complex.
    # It's faster to try fetch all public issues first, then only
    # if necessary try to fetch all issues.
    def issues_limited_count(limit)
      sum = issues(public_only: true).limit(limit).count
      sum < limit ? issues.limit(limit).count : sum
    end

    def projects
      limit_projects.search(query)
    end

    def issues(finder_params = {})
      issues = IssuesFinder.new(current_user, finder_params).execute
      unless default_project_filter
        issues = issues.where(project_id: project_ids_relation)
      end

      issues =
        if query =~ /#(\d+)\z/
          issues.where(iid: $1)
        else
          issues.full_search(query)
        end

      issues.reorder('updated_at DESC')
    end

    def milestones
      milestones = Milestone.where(project_id: project_ids_relation)
      milestones = milestones.search(query)
      milestones.reorder('updated_at DESC')
    end

    def merge_requests
      merge_requests = MergeRequestsFinder.new(current_user).execute
      unless default_project_filter
        merge_requests = merge_requests.in_projects(project_ids_relation)
      end

      merge_requests =
        if query =~ /[#!](\d+)\z/
          merge_requests.where(iid: $1)
        else
          merge_requests.full_search(query)
        end

      merge_requests.reorder('updated_at DESC')
    end

    def default_scope
      'projects'
    end

    def per_page
      20
    end

    def project_ids_relation
      limit_projects.select(:id).reorder(nil)
    end
  end
end
