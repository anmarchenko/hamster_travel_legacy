# frozen_string_literal: true

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all

  resources :errors, only: [] do
    collection do
      get :not_found, :no_access
    end
  end

  devise_for :users,
             only: :omniauth_callbacks,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  scope '(:locale)', locale: /ru|en/ do
    devise_for :users, skip: :omniauth_callbacks

    resources :landing, only: [:index] do
      get :welcome, on: :collection
    end
    resources :users, only: [:show]
    resources :trips, except: [:destroy] do
      collection do
        get :my, :drafts
      end
    end
    resources :messages, only: %i[index destroy update]

    namespace :api do
      resources :cities, only: [:index]
      resources :users, only: %i[index show update] do
        member do
          post :upload_image, :delete_image
          get :planned_trips, :finished_trips, :visited
        end
        resources :manual_cities, only: %i[index create]
      end
      resources :participants, only: [:index]
      resources :trip_invites, only: %i[create destroy]
      resources :trips, only: %i[index destroy] do
        member do
          post :upload_image, :delete_image
        end

        resources :days_sorting, only: %i[index create]
        resources :days, only: [] do
          resources :activities, only: %i[index create]
          resources :transfers, only: %i[index create] do
            collection do
              get :previous_place, :previous_hotel
            end
          end
        end
        resources :days_activities, only: %i[index create]
        resources :days_transfers, only: %i[index create]
        resources :documents
      end
      resources :caterings, only: %i[show update]
      resources :user_shows, only: [:show]
      resources :reports, only: %i[show update]
      resources :budgets, only: %i[show update]
      resources :countries, only: [:show]
    end
  end

  root to: 'landing#welcome'
end
