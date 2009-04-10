class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      # Note
      t.text :note_body
      t.string :note_title
      
      # Task
      t.text :task_description
      t.datetime :task_due_at
      t.datetime :task_completed_at
      
      t.references :type_id
      t.references :project
      
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
