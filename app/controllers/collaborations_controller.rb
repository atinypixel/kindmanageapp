class CollaborationsController < ApplicationController
  
  make_resourceful do
    actions :all
    
    before :index, :show do
      if params[:project_id] ; @project = Project.find(params[:project_id]) ; end
    end
    
    before :create do
      if params[:user_id] && params[:project_id]
        @collaboration.user_id = params[:user_id]
        @collaboration.project_id = params[:project_id]
      end
    end
  end
  
  def ajax_create
    @user, @project = User.find(params[:user_id]), Project.find(params[:project_id])
    @collaboration.create(:user => @user, :project => @project)
  end
  
  def ajax_destroy
    @collaboration = Collaboration.find(params[:collaboration_id])
    @collaboration.destroy
  end
end
