# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Kind::Controller
  helper :all
  helper_method :project_in_view, :entry_data_types
  filter_parameter_logging :password, :password_confirmation
  
  def project_in_view(project_id=nil)
    unless project_id.nil?
      project_id.to_s
    else
      "01"
    end
  end
  
  def entry_data_types
    ["task", "note", "upload"]
  end
  
end


