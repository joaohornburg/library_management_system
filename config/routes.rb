# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'home#index'

  get '*path', to: 'home#index', constraints: ->(request) { !request.xhr? && request.format.html? }

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }, defaults: { format: :json }

      resources :books

      resources :borrowings, only: [:create, :index] do
        member do
          patch :return
        end
      end

      resource :dashboard, only: [:show]
    end
  end
end
