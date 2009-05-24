class Task < ActiveRecord::Base
  belongs_to :entry
  
  validates_presence_of :description, :on => :create, :message => "can't be blank"
end
