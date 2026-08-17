Rails.application.routes.draw do
  resources :beans
  resources :baskets
  
  resources :recipes do
    member do
      post :quick_log
    end
    resources :brews # keep this for your detailed history view later
  end
  
  root "beans#index"
end