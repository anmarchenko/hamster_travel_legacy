Travel::Application.routes.draw do

  devise_for :users
  root to: "dashboard#index" 
  resources :users

end
