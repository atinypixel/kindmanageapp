class AddTaskShowDueDateToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :task_show_due_date, :boolean
  end

  def self.down
    remove_column :entries, :task_show_due_date
  end
end
