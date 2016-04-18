Travel::Application.routes.draw do

  scope '(:locale)', locale: /ru|en/ do
    devise_for :users, controllers: { registrations: 'registrations' }

    resources :users, only: [:show, :edit, :update] do
      member do
        post :upload_photo
      end
    end
    resources :trips do
      member do
        post :upload_photo
      end
    end
    resources :messages, only: [:index, :destroy, :update]

    namespace :api do
      namespace :v2 do
        resources :trips, only: [] do
          resources :days, only: [] do
            resources :activities, only: [:index, :create]
          end
        end
      end
      resources :cities, only: [:index]
      resources :users, only: [:index]
      resources :participants, only: [:index]
      resources :trip_invites, only: [:create, :destroy]
      resources :trips, only: [:show, :update] do
        resources :days, only: [:index, :create, :show, :update]
        resources :days_sorting, only: [:index, :create]
        resources :caterings, only: [:index, :create]
      end
      resources :user_shows, only: [:show]
      resources :budgets, only: [:show]
      resources :countries, only: [:show]
    end
  end

  root to: 'dashboard#index'

end
