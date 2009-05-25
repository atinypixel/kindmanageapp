class RenameAccountsIdToAccountIdInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :accounts_id, :account_id
  end

  def self.down
    rename_column :users, :account_id, :accounts_id
  end
end
