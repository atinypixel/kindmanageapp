class CreateDiscussionsAndModifyIssues < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.string :title
      t.text :body
      t.timestamps
    end
    
    rename_column :issues, :title, :summary
    add_column :workspaces, :exclusive, :boolean, :default => 0
  end

  def self.down
    remove_column :workspaces, :exclusive
    rename_column :issues, :summary, :title
    drop_table :discussions
  end
end
