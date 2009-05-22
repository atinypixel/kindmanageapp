class AddEntryIdToEntryTypeModels < ActiveRecord::Migration
  def self.up
    add_column :notes, :entry_id, :integer
    add_column :tasks, :entry_id, :integer
    add_column :uploads, :entry_id, :integer
  end

  def self.down
    remove_column :uploads, :entry_id
    remove_column :tasks, :entry_id
    remove_column :notes, :entry_id
  end
end
