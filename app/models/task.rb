class Task < ActiveRecord::Base
  
  include Kind::Model::Extensions
  
  belongs_to :entry
  has_many :todos, :dependent => :destroy
  validates_presence_of :description, :on => :create, :message => "can't be blank"
  process_workspaces_for :description
  
end
