class RemoveContentIdFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :content_id
  end

  def self.down
    add_column :entries, :content_id, :integer
  end
end
