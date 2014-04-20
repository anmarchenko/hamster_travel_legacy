Travel::Application.routes.draw do

  scope '(:locale)', locale: /ru|en/ do
    devise_for :users, controllers: { registrations: 'registrations' }

    resources :users, only: [:show, :edit, :update]

    namespace :api do
      resources :cities, only: [:index]
    end
  end

  root to: 'dashboard#index'
  get '/:locale' => 'dashboard#index'

end
