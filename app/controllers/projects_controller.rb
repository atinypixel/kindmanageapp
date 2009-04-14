class ProjectsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :show do
      @entries = current_object.entries
      @types = Type.find(:all)
    end
  end
end
