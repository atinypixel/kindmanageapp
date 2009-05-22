class Note < ActiveRecord::Base
  acts_as_markdown :body
  validates_presence_of :body, :on => :create, :message => "can't be blank"
end
