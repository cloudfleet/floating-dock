Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
      scope :repos do
        get '/', to: 'repositories#index'
        get '/:namespace', to: 'repositories#index'
        get '/:namespace/:name', to: 'repositories#show'
        get '/:namespace/:repository/builds/:id/logs', to: 'builds#logs'
        post '/:namespace/:repository/builds', to: 'builds#new'
      end
      resources :organizations
      resources :users, only: :show
      scope :github do
        post '/pushes/:organization/', to: 'github#push'
      end
    end
  end


  get '/app', to: 'root#index'
  get '/app/*path', to: 'root#index'


end
