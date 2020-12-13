Rails.application.routes.draw do
  get 'groups/index'
  get 'groups/show'
  get 'groups/new'
  get 'groups/edit'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
   root 'groups#index'
end
