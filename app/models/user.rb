class User < ActiveRecord::Base
  acts_as_authenticated
  has_one :account
end
