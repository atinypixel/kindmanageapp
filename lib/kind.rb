module Kind
  module Controller
    def self.included(controller)
      controller.send(:include, UsersAccounts)
    
      controller.class_eval do
        helper_method :current_account, :current_user, :current_user_session, :require_user, :require_no_user, :redirect_back_or_default
      end
    end
  
  
  
    module UsersAccounts
    
      private
      
        def current_account
          subdomain = request.subdomains.first
          # subdomain ||= 'test' if local_request?
          @current_account = Account.find_by_subdomain(subdomain.downcase) if subdomain
        end
    
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = current_account.user_sessions.find
        end
  
        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.record
        end
  
        def require_user
          unless current_user
            store_location
            flash[:notice] = "You must be logged in to access this page"
            redirect_to new_user_session_url
            return false
          end
        end
  
        def require_no_user
          if current_user
            store_location
            flash[:notice] = "You must be logged out to access this page"
            redirect_to account_url
            return false
          end
        end
  
        def store_location
          session[:return_to] = request.request_uri
        end
  
        def redirect_back_or_default(default)
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end
    end
  end
end