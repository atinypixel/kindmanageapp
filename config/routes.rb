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
end
