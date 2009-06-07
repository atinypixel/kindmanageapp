class WorkspacesController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all
    
    before :show do
      if @workspace.project ; @project = @workspace.project ; end
    end
    
    before :destroy do
      @context = params[:context]
    end
    
  end
end
