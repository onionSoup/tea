Rails.application.routes.draw do
  root to: 'orders#show'

  resource  :dashboard,     only: %i(show)
  resource  :help,          only: %i(show)
  resource  :order,         only: %i(show update)
  resource  :period,        only: %i(show)
  resources :order_details, only: %i(destroy)
  resources :sessions,      only: %i(create)
  resources :users,         only: %i(new create edit update)

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
      resource :exchanged,  only: %i(show)
    end
  end

  namespace :admin do
    resource  :dashboard, only: %i(show)
    resource  :postage,   only: %i(show update)
    resource  :period,    only: %i(show update destroy) do
      post :expire
    end
    resource  :setting,   only: %i(show update)

    resources :items
    resources :users do
      resources :order_details, only: %i(index create destroy)
    end
  end
end
