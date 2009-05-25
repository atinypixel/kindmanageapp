class Account < ActiveRecord::Base
  
  authenticates_many :user_sessions
  
  has_many :users, :uniq => true
  accepts_nested_attributes_for :users
  
  has_many :projects, :uniq => true
  has_many :workspaces, :uniq => true
  has_many :entries, :uniq => true
  has_many :collections, :uniq => true
end
