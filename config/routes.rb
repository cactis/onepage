# -*- encoding : utf-8 -*-
Onepage::Application.routes.draw do

  get "qrcodes/lib" => "qrcodes#lib"

  #  resources :qrcodes do
  #    member do
  #      get :new
  #      #get :index
  #    end
  #  end
  # get "qrcodes/new"

  match 'parses' => 'parses#create'

  get "qrcodes/?:text" => "qrcodes#index", :as => "qrcode"

  get "qrcodes" => "qrcodes#index", :as => "qrcode"

  get "converters/html2haml"

  get "converters/haml2html"



  resources :converters do
    collection do
      post 'html2haml'
    end
  end

  resources :pages do
    resources :comments
  end

  match "pages/:id/js/:media", :to => "pages#show"
  match "pages/:id/js/:as/:media", :to => "pages#show"
  match "pages/:id/css/:media", :to => "pages#show"
  match "pages/:id/css/:as/:media", :to => "pages#show"

  resources :books do
    resources :pages
    match "pages/:id/:media", :to => "pages#show"
    match "pages/:id/css/:as/:media", :to => "pages#show"
  end

  match "pages/:id/:media", :to => "pages#show"

  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :scratches, :controller => :snippets
  resources :jspices, :controller => :snippets
  resources :jslibs, :controller => :snippets

  resources :snippets

  resources :templates
  # devise_for :users


  get "welcome/index"


  devise_for :users, :path => "accounts", :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks"
    }
  match "accounts/auth/:provider/unbind", :to => "users#auth_unbind"

  devise_scope :user do
    match '/users/:id' => "accounts#show"
  end
  resources :users, :controller => 'accounts'
  resources :authorizations




#  get '/users/auth/open_id' do
#    auth_hash = request.env['omniauth.auth']
#  end

  # get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'

#  devise_scope :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
#    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
#  end

#  match '/users/auth/facebook' => 'users/omniauth_callbacks#facebook'

#  devise_scope :user do
#    match "auth/open_id" => "users/omniauth_callbacks#open_id"
#  end

  # get user_omniauth_callback '/users/auth/:action/callback(.:format)' {:action=>/facebook|twitter/, :controller=>"users/omniauth_callbacks"}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "welcome#index"


  # config/routes.rb
  match 'switch_user' => 'switch_user#set_current_user'
  # wildcard route that will match anything
  # match ':id' => 'pages#show'

  resources :img
  match 'img/new/:size', :to => 'img#new'
  match '/:size', :to => 'img#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
