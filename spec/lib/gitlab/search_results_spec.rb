require 'spec_helper'

describe Gitlab::SearchResults do
  include ProjectForksHelper

  let(:user) { create(:user) }
  let!(:project) { create(:project, name: 'foo') }
  let!(:issue) { create(:issue, project: project, title: 'foo') }

  let!(:merge_request) do
    create(:merge_request, source_project: project, title: 'foo')
  end

  let!(:milestone) { create(:milestone, project: project, title: 'foo') }
  let(:results) { described_class.new(user, Project.all, 'foo') }

  context 'as a user with access' do
    before do
      project.add_developer(user)
    end

    describe '#count' do
      it "raises an exception for a not countalbe collection" do
        expect { results.count(:foo) }.to raise_error(ArgumentError)
      end

      [:projects, :issues, :merge_requests, :milestones].each do |collection|
        it "returns the total amount of #{collection}" do
          expect(results.count(collection)).to eq(1)
        end

        it "returns the limited amount of #{collection} if the limit is set" do # FIXME
          project2 = create(:project, name: 'foo2')
          create(:issue, project: project2, title: 'foo2')
          create(:merge_request, source_project: project2, title: 'foo2')
          create(:milestone, project: project2, title: 'foo2')

          expect(results.count(collection, limit: 1)).to eq(1)
        end
      end
    end

    describe '#issues_limited_count' do
      context 'when the number of public issues exceeds the limit' do
        before do
          create(:issue, project: project, title: 'foo2')
        end

        it 'runs single SQL query to get the limited amount of issues' do
          expect(results).to receive(:issues).with(public_only: true).and_call_original
          expect(results).not_to receive(:issues).with(no_args).and_call_original

          results.count(:issues, limit: 1)
        end
      end

      context 'when the number of public issues is less than the limit' do
        before do
          create(:issue, :confidential, project: project, title: 'foo2')
        end

        it 'runs multiple queries to get the limited amount of issues' do
          expect(results).to receive(:issues).with(public_only: true).and_call_original
          expect(results).to receive(:issues).with(no_args).and_call_original

          results.count(:issues, limit: 2)
        end
      end
    end

    it 'includes merge requests from source and target projects' do
      forked_project = fork_project(project, user)
      merge_request_2 = create(:merge_request, target_project: project, source_project: forked_project, title: 'foo')

      results = described_class.new(user, Project.where(id: forked_project.id), 'foo')

      expect(results.objects('merge_requests')).to include merge_request_2
    end

    describe '#merge_requests' do
      it 'includes project filter by default' do
        expect(results).to receive(:project_ids_relation).and_call_original

        results.objects('merge_requests')
      end

      it 'it skips project filter if default project context is used' do
        allow(results).to receive(:default_project_filter).and_return(true)

        expect(results).not_to receive(:project_ids_relation)

        results.objects('merge_requests')
      end
    end

    describe '#issues' do
      it 'includes project filter by default' do
        expect(results).to receive(:project_ids_relation).and_call_original

        results.objects('issues')
      end

      it 'it skips project filter if default project context is used' do
        allow(results).to receive(:default_project_filter).and_return(true)

        expect(results).not_to receive(:project_ids_relation)

        results.objects('issues')
      end
    end
  end

  it 'does not list issues on private projects' do
    private_project = create(:project, :private)
    issue = create(:issue, project: private_project, title: 'foo')

    expect(results.objects('issues')).not_to include issue
  end

  describe 'confidential issues' do
    let(:project_1) { create(:project, :internal) }
    let(:project_2) { create(:project, :internal) }
    let(:project_3) { create(:project, :internal) }
    let(:project_4) { create(:project, :internal) }
    let(:query) { 'issue' }
    let(:limit_projects) { Project.where(id: [project_1.id, project_2.id, project_3.id]) }
    let(:author) { create(:user) }
    let(:assignee) { create(:user) }
    let(:non_member) { create(:user) }
    let(:member) { create(:user) }
    let(:admin) { create(:admin) }
    let!(:issue) { create(:issue, project: project_1, title: 'Issue 1') }
    let!(:security_issue_1) { create(:issue, :confidential, project: project_1, title: 'Security issue 1', author: author) }
    let!(:security_issue_2) { create(:issue, :confidential, title: 'Security issue 2', project: project_1, assignees: [assignee]) }
    let!(:security_issue_3) { create(:issue, :confidential, project: project_2, title: 'Security issue 3', author: author) }
    let!(:security_issue_4) { create(:issue, :confidential, project: project_3, title: 'Security issue 4', assignees: [assignee]) }
    let!(:security_issue_5) { create(:issue, :confidential, project: project_4, title: 'Security issue 5') }

    it 'does not list confidential issues for non project members' do
      results = described_class.new(non_member, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).not_to include security_issue_1
      expect(issues).not_to include security_issue_2
      expect(issues).not_to include security_issue_3
      expect(issues).not_to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 1
    end

    it 'does not list confidential issues for project members with guest role' do
      project_1.add_guest(member)
      project_2.add_guest(member)

      results = described_class.new(member, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).not_to include security_issue_1
      expect(issues).not_to include security_issue_2
      expect(issues).not_to include security_issue_3
      expect(issues).not_to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 1
    end

    it 'lists confidential issues for author' do
      results = described_class.new(author, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).to include security_issue_1
      expect(issues).not_to include security_issue_2
      expect(issues).to include security_issue_3
      expect(issues).not_to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 3
    end

    it 'lists confidential issues for assignee' do
      results = described_class.new(assignee, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).not_to include security_issue_1
      expect(issues).to include security_issue_2
      expect(issues).not_to include security_issue_3
      expect(issues).to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 3
    end

    it 'lists confidential issues for project members' do
      project_1.add_developer(member)
      project_2.add_developer(member)

      results = described_class.new(member, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).to include security_issue_1
      expect(issues).to include security_issue_2
      expect(issues).to include security_issue_3
      expect(issues).not_to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 4
    end

    it 'lists all issues for admin' do
      results = described_class.new(admin, limit_projects, query)
      issues = results.objects('issues')

      expect(issues).to include issue
      expect(issues).to include security_issue_1
      expect(issues).to include security_issue_2
      expect(issues).to include security_issue_3
      expect(issues).to include security_issue_4
      expect(issues).not_to include security_issue_5
      expect(results.count(:issues)).to eq 5
    end
  end

  it 'does not list merge requests on projects with limited access' do
    project.update!(visibility_level: Gitlab::VisibilityLevel::PUBLIC)
    project.project_feature.update!(merge_requests_access_level: ProjectFeature::PRIVATE)

    expect(results.objects('merge_requests')).not_to include merge_request
  end
end
