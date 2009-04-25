class Workspace < ActiveRecord::Base
  has_and_belongs_to_many :entries
  
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  # validates_exclusion_of :name, :in => %r(/^([a-zA-Z0-9_-]+)$/), :on => :create, :message => "Only numbers and letters allowed"
end
