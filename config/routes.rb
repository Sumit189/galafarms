Rails.application.routes.draw do
  root 'products#index'
  resources :products
  devise_for :users
  get '/my_products' => 'products#my_products'
  get '/show_product' => 'products#show_product'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end