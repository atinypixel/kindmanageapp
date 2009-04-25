class AddQueueBooleanToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :in_queue, :boolean
  end

  def self.down
    remove_column :entries, :in_queue
  end
end
