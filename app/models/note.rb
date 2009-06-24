class Note < ActiveRecord::Base
  
  include Kind::Model::Extensions
  
  belongs_to :entry
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  process_workspaces_for :title, :body
  
end
