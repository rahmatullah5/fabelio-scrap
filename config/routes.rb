Rails.application.routes.draw do
  root 'products#new'
  resources :products, except: [:update]
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
