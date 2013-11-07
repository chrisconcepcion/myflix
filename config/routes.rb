Myflix::Application.routes.draw do
	root to: 'categories#index'

  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:show] do
  	collection do
  		get 'search', to: 'videos#search', as: 'search'
  	end
  end

  resources :categories, only: [:index, :show]


end
