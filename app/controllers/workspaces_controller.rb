class WorkspacesController < ApplicationController
  make_resourceful do
    actions :all
  end
  
  private
  
  def current_object
    @current_object ||= Workspace.find_by_name(params[:id])
  end
end
