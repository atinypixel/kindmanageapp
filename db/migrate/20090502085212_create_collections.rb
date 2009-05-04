class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.integer :entry_id
      t.integer :workspace_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
