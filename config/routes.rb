Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    member do
      get :get_repositories
      get :repository_info
    end
  end
end
