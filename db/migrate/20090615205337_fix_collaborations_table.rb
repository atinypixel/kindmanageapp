class FixCollaborationsTable < ActiveRecord::Migration
  def self.up
    rename_column :collaborations, :projects_id, :project_id
    rename_column :collaborations, :workspaces_id, :workspace_id
  end

  def self.down
    rename_column :collaborations, :workspace_id, :workspaces_id
    rename_column :collaborations, :project_id, :projects_id
  end
end
