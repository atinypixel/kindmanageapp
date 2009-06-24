ActionController::Routing::Routes.draw do |map|

  map.resource :account do |a|
    a.resources :users
  end
  
  map.resources :users do |u|
    u.resources :collaborations
  end
  
  map.resources :projects do |p|
    p.resources :entries
    p.resources :workspaces
    p.resources :collaborations
  end
  
  map.delete_project "projects/:id/delete", :controller => "projects", :actions => "delete"
  
  map.resources :collaborations
  map.resources :collections
  map.resources :workspaces
  
  map.resource :user_session
  
  map.app_root "/", :controller => "accounts", :conditions => {:subdomain => /.+[^w{3}]/}
  map.public_root "/", :controller => "public", :conditions => {:subdomain => nil}
end
