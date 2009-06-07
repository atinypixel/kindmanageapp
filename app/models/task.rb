class Task < ActiveRecord::Base
  belongs_to :entry
  
  has_many :todos, :dependent => :destroy
  
  validates_presence_of :description, :on => :create, :message => "can't be blank"
  
  alias_attribute :body, :description
end
