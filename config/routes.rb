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

  resources :users, only: [:new, :create, :show] do
    resources :relationships, only: [:create]
  end
  
  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:destroy]
  post 'queue_update', to: 'queue_items#update_queue'

  get '/people', to: 'relationships#index'
  delete '/people', to: 'relationships#destroy'


end
