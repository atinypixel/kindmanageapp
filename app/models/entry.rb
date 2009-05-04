class Entry < ActiveRecord::Base
  acts_as_markdown :note_body
  default_scope :order => 'created_at DESC'
  
  named_scope :just_notes, :conditions => { :type_id => Type.find_by_name("note") }
  named_scope :just_tasks, :conditions => { :type_id => Type.find_by_name("task") }
  
  belongs_to :project
  belongs_to :type
  
  has_many :collections
  has_many :workspaces, :through => :collections
  
  validates_presence_of :note_body, :note_title, :if => :expected_for_notes?
  validates_presence_of :task_description, :if => :expected_for_tasks?
    
  before_create :scope_to_account
  after_save :convert_hashtags_to_workspaces_and_attach
  
  
  
    
  private
    def entry_type_by_name(entry_type)
      Type.find_by_name(entry_type)
    end
    
  
    def convert_hashtags_to_workspaces_and_attach
      primary_content.scan(/#(\w*)$/).flatten.each do |hashtag|
        Workspace.create(:name => hashtag)
      end
    end
    
    def primary_content
      case entry_type
      when "note"
        self.note_body
      when "task"
        self.task_description
      end
    end
      
    def scope_to_account
      self.account_id = self.project.account_id
    end
  
  
    ######################## Validation-specific methods
  
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
