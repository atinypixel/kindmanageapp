class WorkspacesController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all
    
    before :show do
      if @workspace.project ; @project = @workspace.project ; end
    end
    
    before :new do
      @project = Project.find(params[:project])
    end
    
    before :create do
      @project = Project.find(params[:project_id])
      @workspace.account = current_account
    end
        
    before :destroy do
      @context = params[:context]
    end
    
  end
end
