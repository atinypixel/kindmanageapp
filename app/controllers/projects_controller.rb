class ProjectsController < ApplicationController
  before_filter :require_user
  before_filter :require_ownership_or_collaboration, :only => [:show]
  
  make_resourceful do
    actions :all
        
    before :index do 
      @project = Project.new
    end
    
    before :create do
      @project.account = current_account
    end
    
    response_for :create do |wants|
      wants.html {redirect_to project_url(@project)}
      wants.js {
        if @project.save
          @new_project = @project
        end
      }
    end
    
    before :show do
      # @primary_crumb = link_to(@project.name, project_path(@project))
      @entries = @project.entries
    end
  end
  
  protected
    
    # def current_object
    #   @current_object ||= current_account.projects.find(params[:id])
    # end
  
    def current_objects
      @current_objects ||= current_account.projects.find(:all)
    end
end
