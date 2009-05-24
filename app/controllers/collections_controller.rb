class CollectionsController < ApplicationController
  make_resourceful do
    actions :all
    
    before :destroy do
      @context = params[:context]
    end
  end
end
