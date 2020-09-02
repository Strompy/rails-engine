Rails.application.routes.draw do
  namespace :api do
      namespace :v1 do
        resources :merchants, only: [:index, :show, :create, :update, :destroy] do
          # get '/items', to: 'merchant_items#index'
          resources :items, only: [:index], module: :merchants
        end
        resources :items, only: [:index, :show, :create, :update, :destroy]
      end
    end
end
