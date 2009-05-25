class WorkspacesController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all
  end
  
  private
  
  # def current_object
  #   @current_object ||= Workspace.find_by_id(params[:id])
  # end
end
