class AddArchivedBooleanToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :entries, :archived
  end
end
