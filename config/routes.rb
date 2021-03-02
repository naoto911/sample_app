Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get 'guest_login', to: "users#guest_login" #簡単ログイン用に追加 1/20

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'groups#index'
  resources :users
  resources :answers #, :only => [:show, :edit ] 

  resources :groups do
    #member do 2/6 削除 join controller に移行
      #get :join
    #end
    resources :joins do #2/6 join controller作成のため追記
      member do 
        get :permit
        #delete :leave
      end 
    end
    resources :events , :except => [:index ] 
  end

end
