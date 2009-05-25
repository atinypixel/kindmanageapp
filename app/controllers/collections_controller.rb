class CollectionsController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all
    
    before :destroy do
      @context = params[:context]
    end
  end
end
