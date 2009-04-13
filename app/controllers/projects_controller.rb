class ProjectsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :show do
      @entries = current_object.entries
    end
  end
end
