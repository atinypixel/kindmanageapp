class ProjectsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :show do
      @entries = current_object.entries
      @types = Type.find(:all)
    end
    
  end
  
  protected
  
  def current_object
    @current_object ||= current_account.projects.find(params[:id])
  end
  
  def current_objects
    @current_objects ||= current_account.projects.find(:all)
  end
end
