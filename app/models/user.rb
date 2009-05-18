class User < ActiveRecord::Base
  
  # acts_as_authentic
  
  has_one :account
  has_many :entries  
end
