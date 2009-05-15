class RemoveDescriptionFromWorkspaces < ActiveRecord::Migration
  def self.up
    remove_column :workspaces, :description
  end

  def self.down
    add_column :workspaces, :description, :text
  end
end
