class AddNoteShowTitleToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :note_show_title, :boolean
  end

  def self.down
    remove_column :entries, :note_show_title
  end
end
