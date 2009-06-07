class CreateCollaborations < ActiveRecord::Migration
  def self.up
    create_table :collaborations do |t|
      t.references :projects
      t.references :workspaces
      t.references :users
      t.timestamps
    end
  end

  def self.down
    drop_table :collaborations
  end
end
