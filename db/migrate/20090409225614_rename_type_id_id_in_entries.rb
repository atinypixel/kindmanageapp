class RenameTypeIdIdInEntries < ActiveRecord::Migration
  def self.up
    rename_column :entries, :type_id_id, :type_id
  end

  def self.down
    rename_column :entries, :type_id, :type_id_id
  end
end
