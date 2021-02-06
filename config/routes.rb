Rails.application.routes.draw do

  get 'joins/new'
  get 'joins/edit'
  get 'joins/show'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get 'guest_login', to: "users#guest_login" #簡単ログイン用に追加 1/20

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
