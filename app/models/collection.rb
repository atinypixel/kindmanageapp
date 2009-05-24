class Collection < ActiveRecord::Base
  
  default_scope :order => 'position, created_at ASC'
  
  
  belongs_to :workspace
  belongs_to :entry
  belongs_to :account
  
  before_destroy :strip_associated_at_tags_from_entry
  
  private
  
  def strip_associated_at_tags_from_entry
    entry = self.entry
    case entry.content_type_name
    when "note"
      entry.note.update_attributes(:body => entry.note.body.gsub(/\s@#{self.workspace.name}/, "").gsub(/@#{self.workspace.name}/, ""))
    when "task"
      entry.task.update_attributes(:description => entry.task.description.gsub(/\s@#{self.workspace.name}/, "").gsub(/@#{self.workspace.name}/, ""))
    when "upload"
      entry.upload.update_attributes(:description => entry.upload.description.gsub(/\s@#{self.workspace.name}/, "").gsub(/@#{self.workspace.name}/, ""))
    end
  end
end
