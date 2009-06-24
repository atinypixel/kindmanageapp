class Discussion < ActiveRecord::Base
  
  include Kind::Model::Extensions
  
  belongs_to :entry
  process_workspaces_for :subject, :body
  
end
