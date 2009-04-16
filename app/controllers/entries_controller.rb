class EntriesController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :project
        
    before :new do
      @type = Type.find(params[:type])
    end
        
    before :create do
      @project = @entry.project
      @entries = @project.entries
    end
      
    before :edit do
      @context = params[:context]
      @type = Type.find(params[:type])
    end
      
    before :update, :destroy do
      @project = @entry.project
      @entries = @project.entries
      @context = params[:context]
    end
  end
end
