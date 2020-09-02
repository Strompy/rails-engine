Rails.application.routes.draw do
  namespace :api do
      namespace :v1 do
        resources :merchants, only: [:index, :show, :create, :update, :destroy]
        resources :items, only: [:index]
      end
    end
end
