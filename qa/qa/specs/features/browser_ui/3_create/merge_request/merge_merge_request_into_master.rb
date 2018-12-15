# frozen_string_literal: true

module QA
  context 'Create' do
    describe 'Merge to master via web' do
      it 'user merges a merge request into master' do
        Runtime::Browser.visit(:gitlab, Page::Main::Login)
        Page::Main::Login.act { sign_in_using_credentials }

        Resource::MergeRequest.fabricate!

        Page::MergeRequest::Show.perform do |show|
          show.merge!
        end

        expect(page).to have_content('The changes were merged into master')
      end
    end
  end
end
