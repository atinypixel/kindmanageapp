class Task < ActiveRecord::Base
  # acts_as_entry
  validates_presence_of :description, :on => :create, :message => "can't be blank"
  
end
