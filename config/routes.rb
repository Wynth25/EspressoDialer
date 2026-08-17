Rails.application.routes.draw do
  resources :beans do
    collection do
      get :archived
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
    resources :brews # keep this for your detailed history view later
  end
  
  root "recipes#index"
end