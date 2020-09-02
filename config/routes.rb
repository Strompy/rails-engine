Rails.application.routes.draw do
  namespace :api do
      namespace :v1 do
        resources :merchants, only: [:index, :show, :create, :update, :destroy] do
          resources :items, only: [:index], module: :merchants
        end
        resources :items, only: [:index, :show, :create, :update, :destroy] do
          # resources :merchant, only: [:show], module: :items
           # get '/merchant', to: 'merchant#show'
        end
        namespace :items do
          get '/:id/merchant', to: 'merchant#show'
        end
      end
    end
end
