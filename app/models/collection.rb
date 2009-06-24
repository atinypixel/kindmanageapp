class Collection < ActiveRecord::Base
  
  default_scope :order => 'position, created_at ASC'
  
  belongs_to :workspace
  belongs_to :entry
  belongs_to :account
  
end
