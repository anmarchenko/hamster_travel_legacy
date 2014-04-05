Travel::Application.routes.draw do

  scope '(:locale)', locale: /ru|en/ do
    devise_for :users, controllers: { registrations: 'registrations' }

    resources :users, only: [:show, :edit, :update]
  end

  root to: 'dashboard#index'
  get '/:locale' => 'dashboard#index'

end
