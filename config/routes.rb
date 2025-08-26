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
    root 'bulletins#index'

    post 'auth/:provider',          to: 'auth#auth_request', as: :auth_request
    get  'auth/:provider/callback', to: 'auth#callback',     as: :callback_auth
    delete '/logout', to: 'auth#destroy', as: :logout

    resources :bulletins do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    resource :profile, only: :show, controller: 'profile'

    namespace :admin do
      root 'bulletins#moderation'

      resources :bulletins, only: %i[index show] do
        collection { get :moderation }
        member do
          patch :to_moderate
          patch :publish
          patch :reject
          patch :archive
        end
      end

      resources :categories, only: %i[index new create show edit update destroy]
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
