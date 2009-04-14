class EntriesController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :project
    
    before :new do
      @project = Project.find(params[:project_id])
      @type = Type.find(params[:type])
    end
        
    before :edit do
    
    end
    
  end
end
