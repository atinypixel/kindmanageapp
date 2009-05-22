class Entry < ActiveRecord::Base
  acts_as_markdown :body
  default_scope :order => 'created_at DESC'
  
  # attr_accessible :body, :title
    
  # entry types
  has_one :task, :dependent => :destroy
  has_one :note, :dependent => :destroy
  has_one :upload, :dependent => :destroy
  
  accepts_nested_attributes_for :task, :note, :upload
  
  
  # other relationships
  belongs_to :project
  belongs_to :account
  belongs_to :user
  
  
  
  # workspace relationships
  has_many :collections, :uniq => true, :dependent => :destroy
  has_many :workspaces, :through => :collections
  
  after_save :process_workspaces
  after_update :process_workspaces
  
  def data_type_name
    data_model_name = data.class.name || data.class.name || data.class.name
    data_model_name.downcase
  end

  def data
    note || task || upload
  end
  
  private
  
    def process_workspaces
      if at_tags?
        at_tags.each do |at_tag|
          workspace = new_or_existing_workspace(at_tag)
          unless collection_exists_for_at_tag?(workspace)
            workspace.collections.create(:entry => self, :account => self.account)
          else
            self.collections.each do |c|
              c.destroy unless at_tags.include?(c.workspace.name)
            end
          end
        end
      else
        at_tags = " "
        self.collections.each do |c|
          c.destroy unless at_tags.include?(c.workspace.name)
        end
      end
    end
    
    def new_or_existing_workspace(at_tag)
      workspace = Workspace.find_or_create_by_name(at_tag)
      if workspace.created_at < 5.seconds.ago || workspace.account_id.blank?
        workspace.account = self.account
        if self.project.scope_workspaces
          workspace.project = self.project unless workspace.scoped_by_different_project?(self.project)
        end
        workspace.save!
      end
      return workspace
    end
      
    def collection_exists_for_at_tag?(workspace)
      true if at_tags.include?(workspace.name) && workspace.collections.find_by_entry_id(self.id)
    end 
    
    def at_tags
      body.scan(/@(\w+)/).flatten
    end
    
    def at_tags?
      body.scan(/@(\w+)/).length > 0
    end
    
    def body
      if self.note
        self.note.body
      elsif self.task
        self.task.description
      elsif upload
        self.upload.description
      end
    end    
end
