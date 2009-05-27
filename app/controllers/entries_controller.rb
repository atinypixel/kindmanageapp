class EntriesController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all
    belongs_to :project, :account
    
    
    before :show do
      @project = @entry.project
    end
    
    before :new do
      @context = params[:context]
      @content_type = params[:content_type]
      @entry.send("build_#{@content_type}")
    end
        
    before :create do
      @context = params[:context]
      @content_type = @entry.content_type_name
      @entry.account, @entry.user = current_account, current_user
      @project = @entry.project
    end
    
    after :create do
      flash[:notice] = "#{@entry.content_type_name.capitalize} has been successfully added to `#{@entry.project.name}`"
    end
    
    before :edit do
      @context = params[:context]
      @content_type = params[:content_type]
    end
    
    before :update, :destroy do
      @context = params[:context]
      @project = @entry.project
      @entries = @project.entries
    end
  end  
  # def current_object
  #   @current_object ||= current_account.current_object(params[:id])
  # end
end
