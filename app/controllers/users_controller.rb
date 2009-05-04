class UsersController < ApplicationController
  make_resourceful do
    actions :all
  end
  
  private
    
    def current_object
      @current_object ||= current_user
    end
    
    def current_objects
      @current_objects || current_account.users
    end
end
