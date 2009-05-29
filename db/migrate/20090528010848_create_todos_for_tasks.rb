class CreateTodosForTasks < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.references :task
      t.text :description
      t.integer :assigned_id # references an existing user
      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
