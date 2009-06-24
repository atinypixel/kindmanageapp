class RenameDiscussionsTitleToSubject < ActiveRecord::Migration
  def self.up
    rename_column :discussions, :title, :subject
  end

  def self.down
    rename_column :discussions, :subject, :title
  end
end
