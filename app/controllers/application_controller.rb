# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Kind::Controller::Accounts
  include Kind::Controller::Users
  
  before_filter :load_context
  
  layout :current_layout_name
  
  helper :all
  helper_method :project_in_view, :entry_content_types, :project_accessible_by_user?
  filter_parameter_logging :password, :password_confirmation
  
  def current_layout_name
    public_site? ? 'public' : 'application'
  end
  
  def public_site?
    account_subdomain = default_account_subdomain
  end
  
  def project_in_view(project_id=nil)
    unless project_id.nil?
      project_id.to_s
    else
      "01"
    end
  end
  
  def project_accessible_by_user?(project, user)
    true if user.owns_current_account?(current_account) || user.owns_project?(project) || user.belongs_to_project?(project)
  end
  
  def filter_workspaces(string)
    string.gsub(/((?:@[a-zA-z0-9\.\-]+\s*)+)$/, "")
  end
  
  def entry_content_types
    ["note", "task", "discussion"]
  end
  
  def load_context
    @context = params[:controller].singularize
    @context_action = params[:action]
    @context_with_action = "#{params[:action]}_#{params[:controller].singularize}"
  end
  
end