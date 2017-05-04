# encoding: utf-8

require 'spec_helper'
require Rails.root.join('db', 'post_migrate', '20170502101023_clean_up_pending_delete_projects.rb')

describe CleanUpPendingDeleteProjects do
  let(:migration) { described_class.new }
  let!(:admin) { create(:admin) }
  let!(:project) { create(:empty_project, pending_delete: true) }

  describe '#up' do
    it 'only cleans up pending delete projects' do
      create(:empty_project)

      expect do
        migration.up
      end.to change { Project.unscoped.count }.by(-1)
    end
  end
end
