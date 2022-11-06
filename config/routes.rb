Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users'

  namespace :api do
    namespace :v1 do
      resources :events
      resources :event_categories
    end
  end
end
