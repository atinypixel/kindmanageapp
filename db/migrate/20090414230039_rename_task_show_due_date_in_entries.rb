class RenameTaskShowDueDateInEntries < ActiveRecord::Migration
  def self.up
    rename_column :entries, :task_show_due_date, :task_show_due_at
  end

  def self.down
    rename_column :entries, :task_show_due_at, :task_show_due_date
  end
end
