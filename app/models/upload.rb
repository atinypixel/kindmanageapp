class Upload < ActiveRecord::Base
  belongs_to :entry
  
  alias_attribute :body, :description
end
