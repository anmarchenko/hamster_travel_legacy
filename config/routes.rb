Rails.application.routes.draw do

  match '/404', to: 'errors#not_found', via: :all

  resources :errors, only: [] do
    collection do
      get :not_found, :no_access
    end
  end

  scope '(:locale)', locale: /ru|en/ do

    devise_for :users, controllers: { registrations: 'registrations' }

    resources :users, only: [:show, :edit, :update] do
      member do
        post :upload_photo
      end
    end
    resources :trips do
      collection do
        get :my, :drafts
      end
    end
    resources :messages, only: [:index, :destroy, :update]

    namespace :api do
      resources :cities, only: [:index]
      resources :users, only: [:index]
      resources :participants, only: [:index]
      resources :trip_invites, only: [:create, :destroy]
      resources :trips, only: [:index] do
        member do
          post :upload_image
        end

        resources :days_sorting, only: [:index, :create]
        resources :days, only: [] do
          resources :activities, only: [:index, :create]
          resources :transfers, only: [:index, :create] do
            collection do
              get :previous_place, :previous_hotel
            end
          end
        end
        resources :days_activities, only: [:index, :create]
        resources :days_transfers, only: [:index, :create]
      end
      resources :caterings, only: [:show, :update]
      resources :user_shows, only: [:show]
      resources :reports, only: [:show, :update]
      resources :budgets, only: [:show, :update]
      resources :countries, only: [:show]
    end
  end

  root to: 'dashboard#index'

end
