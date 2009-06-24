class Workspace < ActiveRecord::Base
  
  default_scope :order => "name ASC"
  
  named_scope :scoped_by_project, :conditions => "project_id is not null"
  named_scope :not_scoped, :conditions => "project_id is null"
  
  has_many :collections, :uniq => true, :dependent => :destroy, :include => :entry
  has_many :entries, :through => :collections
  
  belongs_to :user
  belongs_to :account
  belongs_to :project
  
  validates_uniqueness_of :name, :message => "must be unique", :scope => :project_id
    
  before_save :format_name
    
  def scoped_by_different_project?(different_project_id)
    false if self.project_id == different_project_id
  end
  
  def scoped_by_project?
    true if self.project
  end
  
  def nice_name
    self.name.gsub(/_/, " ").gsub(/And|Is|Or/) do |word|
      word.downcase
    end
  end
  
  private
    
    def format_name
      # downcase characters and replace spaces with underscores
      self.name = self.name.downcase.gsub(/\s/, "_")
    end
  
end
