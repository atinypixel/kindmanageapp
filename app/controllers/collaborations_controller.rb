class CollaborationsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :create do
      if params[:user_id] && params[:project_id]
        @collaboration.user_id, @collaboration.project_id = params[:user_id], params[:project_id]
      end
    end
  end
end
