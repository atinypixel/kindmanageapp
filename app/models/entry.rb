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
  
  # filter workspaces in and out
  after_save :process_workspaces
  after_update :process_workspaces
  
  
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
    if self.project.scope_workspaces
      workspace = Workspace.find_or_create_by_name_and_project_id(at_tag, self.project_id) {|w| w.account = self.account}
    else
      workspace = Workspace.find_by_name(at_tag, :conditions => "project_id is null") || Workspace.create(:name => at_tag, :account => self.account)
    end
    return workspace
  end
  
  def collection_exists_for_at_tag?(workspace)
    true if at_tags.include?(workspace.name) && workspace.collections.find_by_entry_id(self.id)
  end
  
  def at_tags
    content_body.scan(/((?:@\w+\s*)+)$/).flatten.to_s.scan(/@(\w+)/).flatten
  end
  
  def at_tags?
    content_body.scan(/((?:@\w+\s*)+)$/).flatten.to_s.scan(/@(\w+)/).length > 0
  end
  
  def content_body
    if self.note
      self.note.body
    elsif self.task
      self.task.description
    elsif self.upload
      self.upload.description
    end
  end    
  
  def content_type_name
    content_model_name = content.class.name || content.class.name || content.class.name
    content_model_name.downcase
  end

  def content
    note || task || upload
  end
  
end
