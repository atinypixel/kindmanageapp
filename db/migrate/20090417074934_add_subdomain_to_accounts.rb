class AddSubdomainToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :subdomain, :string
    add_index :accounts, :subdomain, :unique => true
  end

  def self.down
    remove_index :accounts, :column => :subdomain
    remove_column :accounts, :subdomain
  end
end
