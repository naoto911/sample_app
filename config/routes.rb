Rails.application.routes.draw do
  resources :groups, only: [:new, :show, :edit, :index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
   root 'groups#index'
end
