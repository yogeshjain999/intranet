JoshIntranet::Application.routes.draw do


devise_for :users, :path_names => {
    :sign_in => 'login',
    :sign_out => 'logout',
    :controller => {:invitations => 'devise/invitations'},
    :root_path => 'leaves#index'    
  }
  
  match '/signup' => 'organizations#new', via: :get, as: :signup 
  match '/signup' => 'organizations#create', via: :post, as: :signup


  constraints(OrganizationRoutes) do
    match "/" => 'dashboard#index'
    resources :users
    resources :leaves do
      get :approve, on: :member
      put :approve, on: :member
      get :rejectStatus, on: :member
      put :rejectStatus, on: :member
    end

    resources :leave_details
    resources :leave_types

    match '/addleaves' => 'users#addleaves', :via => :get
    match '/users/:user_id/assignleaves' => 'users#assignleaves', :via => [:get, :post], as: :assignleaves
    match '/users/:user_id/profile' => 'users#profile', :via => [:get, :post], as: :profile
    match '/users/:user_id/reinvite' => 'users#reinvite', :via => :get, as: :reinvite
    match '/leavessummary' => 'users#leavessummary', :via => :get,  as: :leavessummary
    match '/users/:user_id/chengeroles' => 'users#chengeroles', :via => [:get, :post], as: :chengeroles
    match '/users/:user_id/chengemanager' => 'users#chengemanager', :via => [:get, :post], as: :chengemanager
    match '/organization/:organization_id/csv' => 'users#upload_csv', :via => [:get, :put ], as: :upload_csv
    match '/managers' => 'users#managers', :via => :get, as: :managers
    match '/leave_summary_for_roles' => 'users#leave_summary_for_roles', :via => :get 
    match '/users/:user_id/leave_summary_on_roles' => 'users#leave_summary_on_roles', :via => [:get, :post], as: :leave_summary_on_roles

  end

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
