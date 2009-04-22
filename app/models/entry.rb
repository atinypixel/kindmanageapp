class Entry < ActiveRecord::Base
  acts_as_markdown :note_body
  default_scope :order => 'created_at DESC'
  belongs_to :project
  belongs_to :type
  # has_and_belongs_to_many :workspaces
  validates_presence_of :note_body, :note_title, :if => :expected_for_notes?
  validates_presence_of :task_description, :if => :expected_for_tasks?
  
  before_create :scope_to_account
  
  
  
  
  private
  
  def create_or_associate_hashtag
    case entry_type
    when "task"
      text = self.task_description
    when "note"
      text = self.note_body
    end
    hashtags = text.strip.split(/(#\S+)/)
    hashtags.each do |tag|
      return
    end
  end
  
  def scope_to_account
    self.account_id = self.project.account_id
  end
  
  
  
  # Validation methods
  
  def expected_for_notes?
    entry_type.include?("note")
  end
  
  def expected_for_tasks?
    entry_type.include?("task")
  end
  
  def entry_type
    self.type.name
  end
  
  def valid_entry_types
    ["task", "note"]
  end
end
