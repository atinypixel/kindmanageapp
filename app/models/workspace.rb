class Workspace < ActiveRecord::Base
  has_many :collections, :uniq => true, :dependent => :destroy
  has_many :entries, :through => :collections
  
  named_scope :scoped_by_project, :conditions => "project_id is not null"

  belongs_to :account
  belongs_to :project
  
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  
  # validates_exclusion_of :name, :in => %r(/^([a-zA-Z0-9_-]+)$/), :on => :create, :message => "Only numbers and letters allowed"
  
  before_save :downcase_name
  
  def to_param
    self.name
  end
  
  def scoped_by_different_project?(different_project)
    unless self.project_id.blank?
      self.project_id != different_project.id
    end
  end
  
  def scoped_by_project?
    true if self.project
  end
  
  private
    
    
    def downcase_name
      self.name = self.name.downcase
    end
  
    def remove_workspaces_without_collections
      Workspace.find(:all).each do |w|
        w.destroy if w.collections.nil?
      end
    end
  
end
