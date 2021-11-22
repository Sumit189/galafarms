Rails.application.routes.draw do
  resources :addresses
  resources :line_items
  resources :carts
  root 'products#index'
  resources :products
  devise_for :users
  get '/my_products' => 'products#my_products'
  get '/show_product' => 'products#show_product'
  get '/addresses/order_info' => 'addresses#order_info'
  post '/addresses/order_info' => 'addresses#order_info'
  get 'product/search' => 'products#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
