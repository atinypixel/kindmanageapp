class Workspace < ActiveRecord::Base
  has_many :collections
  has_many :entries, :through => :collections
  
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  # validates_exclusion_of :name, :in => %r(/^([a-zA-Z0-9_-]+)$/), :on => :create, :message => "Only numbers and letters allowed"
  
  before_save :remove_workspaces_without_collections
  
  def to_param
    self.name.gsub(/_/, "-")
  end
  
  def remove_workspaces_without_collections
    Workspace.find(:all).each do |w|
      w.destroy if w.collections.nil?
    end
  end
  
end
