class Collection < ActiveRecord::Base
  belongs_to :workspace
  belongs_to :entry
end
