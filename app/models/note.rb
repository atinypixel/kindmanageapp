class Note < ActiveRecord::Base
  acts_as_markdown :body
  belongs_to :entry
  validates_presence_of :body, :on => :create, :message => "can't be blank"    
end
