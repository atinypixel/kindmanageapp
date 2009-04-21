class ScopeModelsToAccountAndUser < ActiveRecord::Migration
  def self.up
    add_column :entries, :account_id, :integer
    add_column :entries, :user_id, :integer
    add_column :projects, :account_id, :integer
    add_column :projects, :user_id, :string
    add_column :milestones, :account_id, :integer
    add_column :milestones, :user_id, :integer
    add_column :workspaces, :account_id, :integer
    add_column :workspaces, :user_id, :integer
    add_column :comments, :account_id, :integer
  end

  def self.down
    remove_column :comments, :account_id
    remove_column :workspaces, :user_id
    remove_column :workspaces, :account_id
    remove_column :projects, :user_id
    remove_column :projects, :account_id
    remove_column :milestones, :user_id
    remove_column :milestones, :account_id
    remove_column :entries, :user_id
    remove_column :entries, :account_id
  end
end
