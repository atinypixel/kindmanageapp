class SetupCertify < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      # name will form the sub-domain
      t.string :name, :null => false, :limit => 100
      # for external access
      t.string :api_token, :limit => 32
    end
    
    create_table :users do |t|
      # basic info
      t.string :first_name, :null => false, :limit => 16
      t.string :last_name, :null => false, :limit => 16
      
      # authentication
      t.string :email, :null => false, :limit => 100
      t.string :password, :null => false, :limit => 32
      
      # roles can be simple integers as most applications don't need complex 
      t.integer :role, :null => false, :default => 1, :limit => 1
      
      # for cookie use
      t.string :remember_token, :limit => 32
      t.datetime :remember_token_expires_at
      
      # for deletion
      t.datetime :deleted_at

      t.belongs_to :account
    end
    
    # lots of indexing = superior performance:
    # loading of sub-domain
    add_index :accounts, :name
    # uniqueness
    add_index :users, [:email, :account_id], :unique => true
    # typical authentication:
    add_index :users, [:email, :password, :account_id, :deleted_at]
    # password recovery
    add_index :users, [:remember_token, :remember_token_expires_at, :account_id, :deleted_at], :name => 'by_remember_token'
  end

  def self.down
    drop_table :accounts
    drop_table :users
  end
end
