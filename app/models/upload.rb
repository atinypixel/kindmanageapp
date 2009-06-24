class Upload < ActiveRecord::Base
  
  belongs_to :entry
  has_many :assets
  alias_attribute :for_workspaces, :description
  
end
