Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customer_subscriptions, only: [:create, :update]
      resources :customers, only: [] do
        resources :subscriptions, only: [:index], controller: "customers/subscriptions"
      end
    end
  end
end
