class User < ActiveRecord::Base
  
  acts_as_authentic
  
  # has_one :account
  belongs_to :account
  
  has_many :entries
  has_many :tasks, :through => :entries
  has_many :notes, :through => :entries
  has_many :uploads, :through => :entries
  has_many :workspaces
  
  has_many :collaborations
  has_many :users, :through => :collaborations
  
  
  def name
    self.first_name.capitalize + " " + self.last_name.scan(/^.{1}/).flatten.to_s.capitalize + "."
  end
  
  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end
      
  def self.register(user_params, account_params)
    user_params ||= {}
    account_params ||= {}
    
    account = Account.new(account_params)
    user = User.new(user_params)
  
    begin
      account.rollback_active_record_state! do
        transaction do
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
  
end
