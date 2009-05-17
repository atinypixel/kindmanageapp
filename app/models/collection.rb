class Collection < ActiveRecord::Base
  
  default_scope :order => 'position DESC'
  
  
  belongs_to :workspace
  belongs_to :entry
  belongs_to :account
end
