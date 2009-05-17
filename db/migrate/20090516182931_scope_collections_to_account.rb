class ScopeCollectionsToAccount < ActiveRecord::Migration
  def self.up
    add_column :collections, :account_id, :integer
  end

  def self.down
    remove_column :collections, :account_id
  end
end
