require 'spec_helper'

describe NamespacelessProjectDestroyWorker do
  let!(:project) { create(:empty_project) }

  subject { described_class.new }

  describe "#perform" do
    context 'project has namespace' do
      it 'does not do anything' do
        project = create(:empty_project)

        subject.perform(project.id, project.owner.id, {})

        expect(Project.unscoped.all).to include(project)
      end

      context 'project has no namespace' do
        let(:admin) { create(:admin) }

        context 'project not a fork of another project' do
          before do
            allow_any_instance_of(Project).to receive(:namespace_id).and_return(nil)
          end

          it "deletes the project" do
            subject.perform(project.id, admin, {})

            expect(Project.unscoped.all).not_to include(project)
          end

          it "truncates the project's team" do
            expect_any_instance_of(ProjectTeam).to receive(:truncate)

            subject.perform(project.id, admin, {})
          end

          it 'does not do anything in Project#remove_pages method' do
            expect(Gitlab::PagesTransfer).not_to receive(:new)

            subject.perform(project.id, admin, {})
          end

          it "doesn't call unlink_fork" do
            is_expected.not_to receive(:unlink_fork)

            subject.perform(project.id, admin, {})
          end
        end

        context 'project forked from another' do
          let!(:parent_project) { create(:empty_project) }

          before do
            create(:forked_project_link, forked_to_project: project, forked_from_project: parent_project)
            allow_any_instance_of(Project).to receive(:namespace_id).and_return(nil) # after parent and fork link is created
          end

          it 'closes open merge requests' do
            merge_request = create(:merge_request, source_project: project, target_project: parent_project)

            subject.perform(project.id, admin, {})

            expect(merge_request.reload).to be_closed
          end

          it 'destroys the link' do
            subject.perform(project.id, admin, {})

            expect(parent_project.forked_project_links).to be_empty
          end
        end
      end
    end
  end
end
