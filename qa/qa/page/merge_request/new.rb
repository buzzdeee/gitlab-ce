module QA
  module Page
    module MergeRequest
      class New < Page::Base
        def go_to_new_form
          find('.shortcuts-merge_requests').click
          find('#new_merge_request_link').click
        end

        # def choose_name(name)
        #   fill_in 'project_path', with: name
        # end

        # def add_description(description)
        #   fill_in 'project_description', with: description
        # end

        # def create_new_project
        #   click_on 'Create project'
        # end
      end
    end
  end
end
