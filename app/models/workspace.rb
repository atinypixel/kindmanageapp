class Workspace < ActiveRecord::Base
  
  named_scope :scoped_by_project, :conditions => "project_id is not null"
  named_scope :not_scoped, :conditions => "project_id is null"
  
  has_many :collections, :uniq => true, :dependent => :destroy, :include => :entry
  has_many :entries, :through => :collections
  
  belongs_to :account
  belongs_to :project
  
  validates_uniqueness_of :name, :message => "must be unique", :scope => :project_id
  
  # validates_exclusion_of :name, :in => %r(/^([a-zA-Z0-9_-]+)$/), :on => :create, :message => "Only numbers and letters allowed"
  
  before_save :downcase_name
  
  # def to_param
  #   self.id.to_s
  # end
  
  # def self.find_or_create_by_name(name, project=nil)
  #   workspace = Workspace.find_by_name(name) || Workspace.new(:name => name)
  #   if workspace.new_record?
  #     if project && project.scope_workspaces
  #       workspace.project = project
  #     end
  #     workspace = workspace.save!
  #   elsif workspace.project && workspace.scoped_by_different_project?(project)
  #     workspace.create(:name => name)
  #   end
  #   return workspace
  # end
  
  def scoped_by_different_project?(different_project_id)
    false if self.project_id == different_project_id
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
