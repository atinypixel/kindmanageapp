class Project < ActiveRecord::Base
  has_many :entries, :dependent => :destroy
  
  has_many :tasks
  has_many :notes
  has_many :upload
  
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  
  
  has_many :workspaces, :uniq => true
  belongs_to :account
  
  before_destroy :remove_workspaces_non_destructively
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  def remove_workspaces_non_destructively
    if self.workspaces
      self.workspaces.each do |w|
        w.project_id = ""
        w.save
      end
    end
  end
  
  def number_of_entries_for(type)
    entry_type = Type.find_by_name(type)
    self.entries.send(type).length
  end
end
