class EntriesController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :project
    
    before :show do
    end
    
  end
end
