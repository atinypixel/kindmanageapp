class ProjectsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :show do
      @entries = @project.entries
      @types = Type.find(:all)
    end
  end
end
