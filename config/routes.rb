Karma::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :notes
  resources :notecollections
  
  devise_scope :user do
    delete 'users/sign_out' => 'session#destroy', :as => 'user_sign_out'
  end

  devise_for :users,  :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  
  post 'notes/new/collection/:collection_id' => 'notes#pass', :as => 'collection_pass'
  get 'notes/new/collection/:collection_id' => 'notes#pass_new', :as => 'collection_pass_new'
  match 'tag/:hashtag', :to => "home#tag_search"
  get 'note/:note_id' => 'notecollections#show_note', :as => 'collection_show_note'
  resources :users

  root :to => "home#index"
  match 'home', :to => "home#index"
  match 'map', :to => "home#map"
  match 'seed', :to => "shouts#seed"
  match 'privacy', :to => "home#privacy"
  match 'logs/development', :to => "logs#development"
  match 'logs/production', :to => "logs#production"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
