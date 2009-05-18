class Account < ActiveRecord::Base
  
  # authenticates_many :user_sessions
  
  # has_many :users, :uniq => true
  has_many :projects, :uniq => true
  has_many :workspaces, :uniq => true
  has_many :entries, :uniq => true
  has_many :collections, :uniq => true
  
  def subdomain
    self.name || nil
  end
  
end
