class AddOwnerIdToAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :user_id
    add_column :accounts, :owner_id, :integer
  end

  def self.down
    remove_column :accounts, :owner_id
    add_column :accounts, :user_id, :integer
  end
end
