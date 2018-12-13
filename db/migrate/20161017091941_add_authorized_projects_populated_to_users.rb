class AddAuthorizedProjectsPopulatedToUsers < ActiveRecord::Migration[4.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    add_column :users, :authorized_projects_populated, :boolean
  end
end
