class RemoveTypeIdColumnFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :type_id
  end

  def self.down
    add_column :entries, :type_id, :integer
  end
end
