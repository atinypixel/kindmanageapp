class Entry < ActiveRecord::Base
  acts_as_markdown :note_body
  default_scope :order => 'created_at DESC'
  
  named_scope :just_notes, :conditions => { :type_id => Type.find_by_name("note") }
  named_scope :just_tasks, :conditions => { :type_id => Type.find_by_name("task") }
  
  belongs_to :project
  belongs_to :type
  
  has_many :collections, :uniq => true
  has_many :workspaces, :through => :collections
  
  validates_presence_of :note_body, :note_title, :if => :expected_for_notes?
  validates_presence_of :task_description, :if => :expected_for_tasks?
    
  before_save :scope_to_account
  after_save :process_workspaces
  after_update :process_workspaces
  
  
  
    
  private
  
    
    def process_workspaces
      if hash_tags?
        hash_tags.each do |hash_tag|
          # Create or find a workspace based on hash tag (hash tags are translated into workspaces)
          workspace = new_or_existing_workspace(hash_tag)
          unless collection_exists_for_hash_tag?(workspace)
            # Collect entry inside a workspace if collection doesn't already exist
            workspace.collections.create(:entry => self)
          else
            # Remove collection if no matching hash tag
            self.collections.each do |c|
              c.destroy unless hash_tags.include?(c.workspace.name)
            end
          end
        end
      else
        # If there are absolutely no hash tags, remove orphaned collections
        hash_tags = " "
        self.collections.each do |c|
          c.destroy unless hash_tags.include?(c.workspace.name)
        end
      end
    end
    
    def collection_exists_for_hash_tag?(workspace)
      true if hash_tags.include?(workspace.name) && workspace.collections.find_by_entry_id(self.id)
    end
        
    def collection_exists?(workspace)
      Collection.find_by_workspace_id_and_entry_id(workspace.id, self.id)
    end    
      
    def new_or_existing_workspace(hash_tag)
      Workspace.find_or_create_by_name(hash_tag)
    end
    
    def hash_tags
      body.scan(/#(\w*)/).flatten
    end
    
    def hash_tags?
      body.scan(/#(\w*)/).length > 0
    end
    
    def entry_type_by_name(entry_type)
      Type.find_by_name(entry_type)
    end
    
    def body
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
