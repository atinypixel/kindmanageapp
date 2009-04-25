class AddTaskMilestoneIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :task_milestone_id, :integer
  end

  def self.down
    remove_column :entries, :task_milestone_id
  end
end
