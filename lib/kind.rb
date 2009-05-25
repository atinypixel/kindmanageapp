module Kind
  module Controller
    module Accounts
      def self.included(controller)
        controller.helper_method(:account_domain, :account_subdomain, :account_url, :current_account, :default_account_subdomain, :default_account_url)
      end

      protected

        # TODO: need to handle www as well
        def current_account
          Account.find_by_subdomain(account_subdomain)
        end
        
        def default_account_subdomain
          account_subdomain if ["www", ""].include?(account_subdomain)
        end
        
        def default_account_url( use_ssl = request.ssl? )
          http_protocol(use_ssl) + account_domain
        end

        # def account_url(account_subdomain = default_account_subdomain, use_ssl = request.ssl?)
        #   http_protocol(use_ssl) + account_host(account_subdomain)
        # end
        # 
        # def account_host(subdomain)
        #   account_host = ''
        #   account_host << subdomain + '.'
        #   account_host << account_domain
        # end
        
        def account_subdomain
          request.subdomains.first || ''
        end
        
        def account_domain
          account_domain = ''
          account_domain << request.domain + request.port_string
        end

        def http_protocol( use_ssl = request.ssl? )
          (use_ssl ? "https://" : "http://")
        end
    end
    
    module Users
      def self.included(controller)
        controller.helper_method(:current_account, :current_user, :current_user_session, :require_user, :require_no_user, :redirect_back_or_default)
      end
      
      protected
          
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
  module Model
  end
end