class EntriesController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :project, :account
    
    before :show do
      @project = @entry.project
    end
    
    before :new do
      @type = params[:type]
      @entry.send("build_#{@type}")
    end
        
    before :create do
      @type = @entry.data_type_name
      @entry.account = current_account
      @project = @entry.project
      @entries = @project.entries
    end
    
    after :create do
      flash[:notice] = "#{@entry.data_type_name.capitalize} has been successfully added to `#{@entry.project.name}`"
    end
    
    before :edit do
      @context = params[:context]
      @type = params[:type]
    end
      
    before :update, :destroy do
      @project = @entry.project
      @entries = @project.entries
      @context = params[:context]
    end
    
  end
  
  protected
  
  # def current_object
  #   @current_object ||= current_account.current_object(params[:id])
  # end
end
