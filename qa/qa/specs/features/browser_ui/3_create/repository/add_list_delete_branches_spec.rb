# frozen_string_literal: true

module QA
  context 'Create' do
    describe 'Create, list, and delete branches via web' do
      let(:location) do
        Page::Project::Show.perform(&:repository_clone_http_location).uri
      end

      commit_message_on_master_branch = 'Add file.txt'
      second_branch = 'second-branch'
      commit_message_on_second_branch = 'Add file-2.txt'
      third_branch = 'third-branch'
      commit_message_on_third_branch = 'Add file-3.txt'

      before do
        Runtime::Browser.visit(:gitlab, Page::Main::Login)
        Page::Main::Login.perform(&:sign_in_using_credentials)

        # 1 - Create project with default master branche
        project = Resource::Project.fabricate! do |proj|
          proj.name = 'project-qa-test'
          proj.description = 'project for qa test'
        end
        project.visit!

        Git::Repository.perform do |repository|
          repository.uri = location
          repository.use_default_credentials

          repository.act do
            # 2 - Clone the project
            clone
            configure_identity('GitLab QA', 'root@gitlab.com')
            # 3 - Create a file and push it to master
            commit_file('file.txt', 'Test file 1', commit_message_on_master_branch)
            push_changes
            # 4 - Create a second branch and push a file to it
            checkout_new_branch(second_branch)
            commit_file('file-2.txt', 'Test file 2', commit_message_on_second_branch)
            push_changes(second_branch)
            # 5 - Checkout to master and merge second branch to it
            checkout('master')
            merge(second_branch)
            push_changes
            # 6 - Create a third branch and push a file to it
            checkout_new_branch(third_branch)
            commit_file('file-3.txt', 'Test file 3', commit_message_on_third_branch)
            push_changes(third_branch)
          end
        end
      end

      it 'branches are correctly listed after CRUD operations' do
        Page::Project::Show.perform(&:wait_for_push)

        # 7 - Visit the project's branches page
        repository_menu = Page::Project::Menu.new
        # @TODO: Implement hover on repository and then click on branches
        repository_menu.click_repository
        repository_menu.click_branches

        # 8 - Assert that the master, second-branch and third-branch are present
        expect(page).to have_content('master')
        expect(page).to have_content(second_branch)
        expect(page).to have_content(third_branch)
        expect(page).to have_content(commit_message_on_second_branch)
        expect(page).to have_content(commit_message_on_third_branch)

        # 9 - Assert that the second-branch branch has a blue merged badge

        # 10 - Delete the third-branch branch

        # 11 - Assert that the third-branch isn't listed anymore
        # expect(page).not_to have_content(third_branch)

        # 12 - Click the Delete merged branches button
        page.click_link('Delete merged branches')
        page.accept_alert

        expect(page).to have_content(
          'Merged branches are being deleted. This can take some time depending on the number of branches. Please refresh the page to see changes.'
        )

        # 13 - Assert that the second-branch isn't listed anymore
        # expect(page).not_to have_content(second_branch)
      end
    end
  end
end