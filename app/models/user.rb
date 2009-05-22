class User < ActiveRecord::Base
  
  acts_as_authentic
  
  has_one :account
  
  has_many :entries
  has_many :tasks, :through => :entries
  has_many :notes, :through => :entries
  has_many :uploads, :through => :entries
  
  before_save :create_account
        
    
  def self.register(user_params, account_params, host = 'kindmanage.dev')
    user_params ||= {}
    account_params ||= {}
  
    # you can choose to provide a password field, or have a password generated
    # we'll default it here if you haven't provided a field
    user_params[:password] ||= encrypt(Time.now)[0..8]
  
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
            # if saved: send email notification of success
            ::Notifier.deliver_registration(user, account, user_params[:password], host)
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
