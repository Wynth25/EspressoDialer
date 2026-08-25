Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :beans do

    collection do
      get :archived
      patch :sort
    end

    member do
      patch :archive
      patch :update_freeze
    end

  end

  resources :baskets
  
  resources :recipes do

    member do
      post :quick_log
    end

    resources :brews

  end
  
  root "recipes#index"
  
end