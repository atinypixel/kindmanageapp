class Task < ActiveRecord::Base
  belongs_to :entry
  
  has_many :todos
  
  validates_presence_of :description, :on => :create, :message => "can't be blank"
end
