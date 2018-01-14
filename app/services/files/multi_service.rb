module Files
  class MultiService < Files::BaseService
    UPDATE_FILE_ACTIONS = %w(update move delete).freeze

    def create_commit!
      handler = Lfs::FileModificationHandler.new(project, @branch_name)

      actions = actions_after_lfs_transformation(handler, params[:actions])

      success = commit_actions!(actions)

      handler.on_success if success

      success
    end

    private

    def actions_after_lfs_transformation(handler, actions)
      actions.map do |action|
        if action[:action] == 'create'
          content = handler.new_file(action[:file_path], action[:content])
          action[:content] = content
          action
        else
          action
        end
      end
    end

    def commit_actions!(actions)
      repository.multi_action(
        current_user,
        message: @commit_message,
        branch_name: @branch_name,
        actions: actions,
        author_email: @author_email,
        author_name: @author_name,
        start_project: @start_project,
        start_branch_name: @start_branch
      )
    rescue ArgumentError => e
      raise_error(e)
    end

    def validate!#TODO: Do we need to transform the actions earlier so we can validate transformed content?
      super

      params[:actions].each { |action| validate_file_status!(action) }
    end

    def validate_file_status!(action)
      return unless UPDATE_FILE_ACTIONS.include?(action[:action])

      file_path = action[:previous_path] || action[:file_path]

      if file_has_changed?(file_path, action[:last_commit_id])
        raise_error("The file has changed since you started editing it: #{file_path}")
      end
    end
  end
end
