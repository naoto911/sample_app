Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get 'guest_login', to: "users#guest_login" #簡単ログイン用に追加 1/20

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index' #'groups#index'
  get '/groups/:id', to: 'home#index'
  get '/groups/', to: 'home#index'
  get '/groups/new', to: 'home#index'
  get '/groups/:id/event', to: 'home#index'
  get '/groups/:id/member', to: 'home#index'
  get '/groups/:id/edit', to: 'home#index'

  resources :users
  resources :answers #, :only => [:show, :edit ] 

  namespace :api, {format: 'json'} do
    namespace :v1 do

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