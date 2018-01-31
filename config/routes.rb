Rails.application.routes.draw do

  root to: 'videos#index', via: :get
  get 'terms', to: 'main#terms', as: :terms
  get 'about', to: 'main#about', as: :about

  resource :session, only: %i[new create destroy]

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  get '/videos/notifications', as: :notifications

  resources :videos, only: %i[index show]

  namespace :account do
    resources :videos, only: %i[index new edit create update destroy]
  end

end
