Myflix::Application.routes.draw do
	root to: 'sessions#welcome'

  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:show] do
  	collection do
      get 'search', to: 'videos#search', as: 'search'
    end
    resources :queue_items, only: [:create]
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  get '/home', to: 'categories#index', as: 'home'
  
  resources :sessions, only: [:create]

  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :show] do
    resources :relationships, only: [:create]
  end

  get 'register/:invitation_token', to: 'users#new_with_invitation_token', as: 'register_token'
  get 'register', to: 'users#new'
 
  
  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:destroy]
  post 'queue_update', to: 'queue_items#update_queue'

  get '/people', to: 'relationships#index'
  delete '/people', to: 'relationships#destroy'

  get 'forgot_password', to: 'forgot_passwords#new'
  post 'forgot_password', to: 'forgot_passwords#create'
  get 'confirm_password_reset', to: 'forgot_passwords#confirm'

  get 'password_reset/:token', to: 'password_resets#new', as: 'password_reset'
  post 'password_reset/:token', to: 'password_resets#create'
  get 'invalid_token', to: 'password_resets#invalid_token'

  get 'invite', to: 'invitations#new'
  resources :invitations, only: [:create]
end
