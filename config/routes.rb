Rails.application.routes.draw do
  resources :line_items
  resources :carts
  root 'products#index'
  resources :products
  devise_for :users
  get '/my_products' => 'products#my_products'
  get '/show_product' => 'products#show_product'
  get '/checkout' => 'carts#checkout'
  get '/pay' => 'carts#pay'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
