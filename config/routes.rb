Rails.application.routes.draw do
  root to: 'users#new'

  resource  :order,         only: %i(show)
  resource  :period_notice, only: %i(show)

  resources :order_details, only: %i(index create destroy)
  resources :sessions,      only: %i(create)
  resources :users,         only: %i(new create)

  match '/login',  to: 'sessions#new',     via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'

  resources :orders, only: %i() do
    collection do
      resource :registered, only: %i(show) do
        post :order
      end
      resource :ordered,    only: %i(show) do
        post :arrive
      end
      resource :arrived,    only: %i(show) do
        post :exchange
      end
      resource :exchanged,  only: %i(show destroy)
    end
  end

  namespace :admin do
    resource  :period, only: %i(show edit update)
    resources :items
    resources :users do
      resources :order_details, only: %i(index create destroy)
    end
  end
end
