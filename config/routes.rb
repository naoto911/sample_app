Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 「SPA用のrouting」
  root 'home#index' #'groups#index'

  #group関連
  get '/groups/:id', to: 'home#index'
  get '/groups/', to: 'home#index'
  get '/groups/new', to: 'home#index'
  get '/groups/:id/detail', to: 'home#index'
  get '/groups/:id/event', to: 'home#index'
  get '/groups/:id/member', to: 'home#index'
  get '/groups/:id/edit', to: 'home#index'

  #evnet関連
  get '/groups/:id/events/new', to: 'home#index'
  get '/groups/:id/events/:event_id', to: 'home#index'
  get '/groups/:id/events/:event_id/edit', to: 'home#index'

  #user関連
  get '/login', to: 'home#index'

  get '/users/:id', to: 'home#index'
  get '/users/new', to: 'home#index'
  get '/users/:id/edit', to: 'home#index'


  #「API用のrouting」

  # resources :users
  resources :answers #, :only => [:show, :edit ] 

  namespace :api, {format: 'json'} do
    namespace :v1 do

      get '/login', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      delete '/login', to: 'sessions#destroy'
      get 'guest_login', to: "users#guest_login" #簡単ログイン用に追加 1/20

      resources :users

      resources :groups do #do
        #member do 2/6 削除 join controller に移行
          #get :join
        #end
        resources :joins do #2/6 join controller作成のため追記
          member do 
            get :permit
            delete :leave #3/2 join leave処理の追加
          end 
        end
        resources :events , :except => [:index ] 
      end

    end
  end

end