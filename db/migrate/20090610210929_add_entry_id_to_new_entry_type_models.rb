class AddEntryIdToNewEntryTypeModels < ActiveRecord::Migration
  def self.up
    add_column :discussions, :entry_id, :integer
  end

  def self.down
    remove_column :discussions, :entry_id
  end
end
