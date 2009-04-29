class EntriesController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :project, :account
    
    before :show do
      @project = @entry.project
    end
    
    before :new do
      @type = Type.find(params[:type])
    end
        
    before :create do
      @project = current_object.project
      @entries = @project.entries
    end
    
    after :create do
      flash[:notice] = "#{current_object.type.name.capitalize} has been successfully added to `#{current_object.project.name}`"
    end
    
    before :edit do
      @context = params[:context]
      @type = Type.find(params[:type])
    end
      
    before :update, :destroy do
      @project = current_object.project
      @entries = @project.entries
      @context = params[:context]
    end
    
  end
  
  protected
  
  # def current_object
  #   @current_object ||= current_account.current_object(params[:id])
  # end
end
