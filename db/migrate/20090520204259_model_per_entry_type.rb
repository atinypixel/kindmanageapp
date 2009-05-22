class ModelPerEntryType < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.text :description
      t.references :project
      t.references :user
      t.references :account
      t.references :entry
      t.timestamps
    end
    
    create_table :notes do |t|
      t.text :body
      t.string :title
      t.references :project
      t.references :user
      t.references :account
      t.references :entry
      t.timestamps
    end
    
    create_table :uploads do |t|
      t.text :description
      t.references :entry
      t.timestamps
    end
    
    create_table :assets do |t|
      t.references :upload
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
    drop_table :uploads
    drop_table :notes
    drop_table :notes
    drop_table :tasks
  end
end
