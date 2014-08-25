Rails.application.routes.draw do
  root to: 'sessions#new'

  resources :details,  only: %i(index create destroy)
  resources :sessions, only: %i(create)
  resources :users,    only: %i(new create)

  match '/login',  to: 'sessions#new',     via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'

  namespace :admin do
    resource  :orders do
      collection do
        resource :preparing, only: %i(show) do
          post :perchase
        end
        resource :perchased, only: %i(show) do
          post :arrive
        end
        resource :arrived,   only: %i(show) do
          post :exchange
        end
      end
    end
    resources :items
    resources :users do
      resources :details, only: %i(index create destroy)
    end
  end
end
