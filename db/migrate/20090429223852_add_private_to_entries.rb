class AddPrivateToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :private, :boolean
  end

  def self.down
    remove_column :entries, :private
  end
end
