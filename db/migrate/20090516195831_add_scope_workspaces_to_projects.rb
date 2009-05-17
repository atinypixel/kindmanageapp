class AddScopeWorkspacesToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :scope_workspaces, :boolean
    add_column :workspaces, :project_id, :integer
  end

  def self.down
    remove_column :workspaces, :project_id
    remove_column :projects, :scope_workspaces
  end
end
