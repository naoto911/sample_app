Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'groups#index'
  resources :users
  resources :answers #, :only => [:show, :edit ] 

  resources :groups do
    member do
      get :join
    end
    resources :events , :except => [:index ] 
  end

end
