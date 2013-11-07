Myflix::Application.routes.draw do
	root to: 'categories#index'

  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:show]
  resources :categories, only: [:index, :show]
end
