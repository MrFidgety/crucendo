Rails.application.routes.draw do
  
  root                        'users#show'
  post    '/'             =>  'users#create'
  post    'changemyemail' =>  'users#new_email'
  post    'unexpected'    =>  'goals#unexpected'
  get     'help'          =>  'static_pages#help'
  get     'resend'        =>  'users#resend'
  get     'profile'       =>  'users#edit'
  get     'wants'         =>  'goals#index'
  patch   'profile'       =>  'users#edit'
  delete  'logout'        =>  'sessions#destroy'
  
  resources :users,               only: :update
  resources :account_activations, only: :edit
  resources :sessions,            only: :edit
  resources :change_user_email,   only: :edit
  resources :interactions,        only: [:index, :show, :update]
  resources :subscriptions,       only: [:index, :update]   
  
  resources :goals do
    post 'improve', on: :member
  end
  
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :questions do
      post :import, on: :collection
    end
    resources :topics do
      post :activate_questions, on: :member
    end
    resources :authors
    resources :skills
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
