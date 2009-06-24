module Kind
  module Controller
    module Accounts
      def self.included(controller)
        controller.helper_method(
          :current_account, 
          :account_domain, 
          :account_subdomain, 
          :default_account_url,
          :default_account_subdomain,
          :current_account_owned_by? )
      end

      protected
        
        def current_account_owned_by?(user)
          current_account.owner_id == user.id
        end
        
        def current_account
          Account.find_by_subdomain(account_subdomain)
        end
        
        def default_account_subdomain
          account_subdomain if ["www", ""].include?(account_subdomain)
        end
        
        def default_account_url( use_ssl = request.ssl? )
          http_protocol(use_ssl) + account_domain
        end

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
        
        # TODO: Make account_url and account_host methods work
        # def account_url(account_subdomain = default_account_subdomain, use_ssl = request.ssl?)
        #   http_protocol(use_ssl) + account_host(account_subdomain)
        # end
        # 
        # def account_host(subdomain)
        #   account_host = ''
        #   account_host << subdomain + '.'
        #   account_host << account_domain
        # end
    end
    module Users
      def self.included(controller)
        controller.helper_method(
          :current_user, 
          :current_user_session, 
          :require_user, 
          :require_no_user, 
          :require_ownership_or_collaboration, 
          :redirect_back_or_default, 
          :created_by_current_user?, 
          :created_by_user?,
          :current_user?)
      end
      
      protected
        
        def current_user?(user)
          current_user.id == user.id
        end
        
        def created_by_current_user?(object)
          object.user_id == current_user.id.to_s
        end
        
        def created_by_user?(object, user)
          object.user_id == user.id
        end
        
        def require_ownership_or_collaboration
          case @context
          when "project"
            # Allow access if user owns account or owns project or belongs to project via collaboration
            unless current_user.owns_current_account?(current_account) || current_user.owns_project?(current_object) || current_user.belongs_to_project?(current_object)
              redirect_to account_url
            end
          end
          
        end
        
        def require_account_owner
          unless current_user && current_user.id == current_account.owner_id
            store_location
            flash[:notice] = "You must be an account owner to access this page"
            redirect_to account_url
            return false
          end
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
  
        def owned_by_current_user?(object)
          true if object.user_id == current_user.id.to_s
        end
  
        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.record
        end
  
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = current_account.user_sessions.find
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
    module Extensions
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        def acts_as_layer_for(*models)
          models.each do |model_name|
            has_one model_name, :dependent => :destroy
            accepts_nested_attributes_for model_name
          end
        end
        
        def process_workspaces_for(*columns)
          before_save do |record|
            columns.each do |column|
              unless record.send(column).blank? 
                process_workspaces(record, column)
              end
            end
          end
        end
        
        private #####################################################
        
          def process_workspaces(record, column)
            at_tags = record.send(column).scan(/((?:@[a-zA-z0-9\.\-]+\s*)+)$/).flatten.to_s.scan(/@(\S+)/).flatten
            if at_tags.any?
              at_tags.each do |at_tag|
                workspace = new_or_existing_workspace(at_tag, record.entry)
                unless collection_exists?(at_tags, record.entry, workspace)
                  workspace.collections.create(:entry => record.entry, :account => record.entry.account)
                end
              end
            end
            record.attributes = { column.to_sym => record.send(column).gsub(/((?:@[a-zA-z0-9\.\-]+\s*)+)$/, "") }
          end
          
          def collection_exists?(at_tags, entry, workspace)
            true if workspace.collections.find_by_entry_id(entry.id)
          end
          
          def new_or_existing_workspace(at_tag, entry)
            if entry.project.scope_workspaces
              exclusive_workspace = Workspace.find_by_name(at_tag, :conditions => {:exclusive => true})
              unless exclusive_workspace.nil?
                workspace = exclusive_workspace
              else
                workspace = Workspace.find_or_create_by_name_and_project_id(at_tag, entry.project_id) {|w| w.account = entry.account}
              end
            else
              workspace = Workspace.find_by_name(at_tag, :conditions => "project_id is null") || Workspace.create(:name => at_tag, :account => entry.account)
            end
            return workspace
          end          
      end
    end
  end
end