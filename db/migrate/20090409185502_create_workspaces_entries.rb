class CreateWorkspacesEntries < ActiveRecord::Migration
  def self.up
    create_table :workspaces_entries do |t|
      t.integer :workspace_id
      t.integer :entry_id
    end
  end

  def self.down
    drop_table :workspaces_entries
  end
end
