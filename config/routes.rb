Rails.application.routes.draw do
  namespace :api do
      namespace :v1 do
        namespace :items do
          get '/:id/merchant', to: 'merchant#show'
          get '/find', to: 'search#show'
          get '/find_all', to: 'search#index'
        end

        namespace :merchants do
          get '/find', to: 'search#show'
          get '/find_all', to: 'search#index'
          get '/most_revenue', to: 'most_revenue#index'
          get '/most_items', to: 'most_items#index'
        end

        resources :merchants, only: [:index, :show, :create, :update, :destroy] do
          resources :items, only: [:index], module: :merchants
        end

        resources :items, only: [:index, :show, :create, :update, :destroy] do
        end
      end
    end
end
