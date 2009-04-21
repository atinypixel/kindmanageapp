class Project < ActiveRecord::Base
  has_many :entries
  belongs_to :account
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  def number_of_entries_for(type)
    entry_type = Type.find_by_name(type)
    entries = Entry.find(:all, :conditions => {:type_id => entry_type.id, :project_id => self.id})
    entries.length
  end
  
  private
  
  def scope_to_account
    
  end
end
