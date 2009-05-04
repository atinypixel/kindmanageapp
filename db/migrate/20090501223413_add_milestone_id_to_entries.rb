class AddMilestoneIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :milestone_id, :integer
  end

  def self.down
    remove_column :entries, :milestone_id
  end
end
