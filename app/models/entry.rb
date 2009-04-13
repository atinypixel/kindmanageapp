class Entry < ActiveRecord::Base
  acts_as_markdown :note_body
  default_scope :order => 'created_at DESC'
  belongs_to :project
  belongs_to :type
  has_and_belongs_to_many :workspaces
end
