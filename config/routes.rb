Karma::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :notes
  resources :notecollections

  devise_for :users,  :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

  namespace :api do
  namespace :v1 do
    devise_scope :user do
      post 'registrations' => 'registrations#create', :as => 'register'
      post 'sessions' => 'sessions#create', :as => 'login'
      delete 'sessions' => 'sessions#destroy', :as => 'logout'
      post 'registrations/facebook' => 'registrations#facebook', :as => 'fb_register'
      post 'sessions/facebook' => 'sessions#facebook', :as => 'fb_login'

    end
    get 'shouts/lat/:lat/lon/:lon/rad/:rad/units/:units' => 'shouts#index', :as => 'shouts'
    get 'shouts/lat/:lat/lon/:lon/rad/:rad' => 'shouts#index', :as => 'shouts_short'
    get 'shouts/recent'           => 'shouts#recent',         :as => 'shouts_recent'    
    get 'shouts/:shout_id' => 'shouts#show', :as => 'shouts_info'
    post 'shouts/new' => 'shouts#create', :as => 'submission'
    get 'users/:user_id/profile' => 'profile#show', :as => 'profile'
    post 'users/profile/update' => 'profile#update', :as => 'update_profile'
    post 'users/profile/upload' => 'profile#upload', :as => 'upload_profile_pic'
    get 'users/:user_id/shouts' => 'shouts#user_shouts', :as => 'user_shouts'
    post 'shouts/:shout_id/comment' => 'comments#create', :as => 'comment_create'

    post 'users/:followee_id/follow' => 'friendships#create', :as => 'friendship_create'
    get 'users/:follower_id/friendships' => 'friendships#retrieve', :as => 'friendships_retrieve'
    
    
    post 'shouts/:shout_id/upload' => 'shouts#upload', :as => 'upload_shout_pic'
    post 'shouts/:shout_id/amplify/:score' => 'shouts#amplify', :as => 'shout_amplify'
    get 'shouts/hashtag/:hashtag' => 'shouts#hashtag_search', :as => 'hashtag_search'
    delete 'shouts/:shout_id'     => 'shouts#destroy',        :as => 'shouts_destroy'

  end
  end

  resources :users

  root :to => "home#index"
  match 'home', :to => "home#index"
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
