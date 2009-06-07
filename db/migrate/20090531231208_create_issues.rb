class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.references :entry
      t.string :title
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
