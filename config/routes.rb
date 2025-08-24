# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount ActiveStorage::Engine => '/rails/active_storage'

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  scope module: :web do
    post 'auth/:provider',          to: 'auth#auth_request', as: :auth_request
    get  'auth/:provider/callback', to: 'auth#callback',     as: :callback_auth
    # get 'auth/:provider', to: 'auth#request'
    delete '/logout', to: 'auth#destroy', as: :logout

    resources :bulletins, only: %i[index show new create edit update]
    root 'bulletins#index'
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
