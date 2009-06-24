class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_many :projects
  
  belongs_to :account
  
  has_many :entries
    
  has_one :workspace
  
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  before_save :create_user_workspace_if_none
  
  def name
    self.first_name.capitalize + " " + self.last_name.scan(/^.{1}/).flatten.to_s.capitalize + "."
  end
  
  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end
     
  def private_workspace
    Workspace.find_by_name(user_workspace_name, :conditions => "project_id is null")
  end
   
  def user_workspace_name
    self.first_name.downcase + "_" + self.last_name.downcase
  end
    
  def owns?(object)
    if object.user_id
      object.user_id == id
    end
  end
  
  def owns_project?(project)
    project.user_id == id.to_s
  end
  
  def owns_current_account?(current_account)
    true if current_account.owner_id == id
  end
  
  def belongs_to_project?(project)
    true unless collaborations.find_by_project_id(project.id.to_s).nil?
  end
  
  def belongs_to_workspace?(workspace)
    true unless collaborations.find_by_workspace_id(workspace.id).nil?
  end
  
  def self.register(user_params, account_params)
    user_params ||= {}
    account_params ||= {}
    
    account = Account.new(account_params)
    user = User.new(user_params)
  
    begin
      account.rollback_active_record_state! do
        transaction do
          # set user as owner of account
          account.owner_id = user.id
          # save the account
          account.save!
          # assign the user to it
          user.account_id = account.id
          # save the user
          if user.save!
            # do nothing
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      # do nothing
    end
    # return the pair as an array
    [user, account]
  end
  
  private
  
    def create_user_workspace_if_none
      user_name = self.first_name.downcase + "_" + self.last_name.downcase
      existing_workspace = Workspace.find_by_name(user_name, :conditions => "project_id is null")
      if existing_workspace.nil?
        Workspace.create(:name => user_name)
      end
    end
  
end
