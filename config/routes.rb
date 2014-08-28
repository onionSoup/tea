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
          post :place
        end
        resource :place,     only: %i(show) do
          post :arrive
        end
      end
      resource :arrived,   only: %i(show)
    end
    resources :items
    resources :users do
      resources :details, only: %i(index create destroy)
    end
  end
end
