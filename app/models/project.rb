class Project < ActiveRecord::Base
  
  has_many :entries, :dependent => :destroy
    
  has_many :collaborations
  has_many :users, :through => :collaborations
  belongs_to :user
  
  has_many :workspaces, :uniq => true
  
  belongs_to :account
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
    
end
