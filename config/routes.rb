ActionController::Routing::Routes.draw do |map|

  map.resource :account do |a|
    a.resources :users
  end
  
  map.resources :projects do |p|
    p.resources :entries
    p.resources :notes
    p.resources :tasks
    p.resources :uploads
    p.resources :workspaces
  end
  
  map.resources :collections
  map.resources :workspaces
  map.resource :user_session
  
  map.app_root "/", :controller => "accounts", :conditions => {:subdomain => /.+[^w{3}]/}
  map.public_root "/", :controller => "public", :conditions => {:subdomain => nil}
  
  # map.root :controller => "user_sessions", :action => "new"
  
  
  
  
  
  # map.root :controller => 'accounts'
  

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  
end
