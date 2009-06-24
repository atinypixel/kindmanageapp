class Entry < ActiveRecord::Base
  include Kind::Model::Extensions
  
  default_scope :order => 'created_at DESC'
  
  acts_as_markdown :body
  acts_as_layer_for :task, :note, :discussion, :upload
    
  # workspace relationships
  has_many :collections, :uniq => true, :dependent => :destroy, :include => :workspace
  has_many :workspaces, :through => :collections
    
  # other relationships
  belongs_to :project
  belongs_to :account
  belongs_to :user
  
  # before_update :adjust_updated_at
      
  def archive_it(entry)
    entry.archived = true
  end
  
  def by_line(current_user)
    if self.user == current_user
      "You"
    else
      self.user.name
    end
  end
  
  def owned_by_current_user?(current_user)
    self.user == current_user
  end
      
  def title
    case content_type
    when "note"
      content.title
    when "discussion"
      content.subject
    when "task"
      content.description
    end
  end
  
  # def adjust_updated_at
  #   self.updated_at = self.content.updated_at
  # end
  
  def content
    try(content_type)
  end
  
end
