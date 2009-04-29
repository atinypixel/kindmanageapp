class Account < ActiveRecord::Base
  
  authenticates_many :user_sessions
  
  has_many :users
  has_many :projects
end
