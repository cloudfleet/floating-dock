Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        token_validations:  'overrides/token_validations',
        sessions:  'overrides/sessions'
      }
      get '/dashboard', to: 'dashboard#show'
      scope :repos do
        get '/', to: 'repositories#index'
        get '/:namespace', to: 'repositories#index'
        post '', to: 'repositories#create'
        get '/:namespace/:name', to: 'repositories#show'
        put '/:namespace/:name', to: 'repositories#update'
        get '/:namespace/:repository/builds/:id/logs', to: 'builds#logs'
      end
      resources :organizations do
        member do
          get 'show_api_key'
          post 'generate_api_key'
        end
      end
      resources :users, only: :show do
        member do
          get 'show_api_key'
          post 'generate_api_key'
        end
      end
      scope :github do
        post '/pushes/:namespace/:api_key', to: 'github#push'
      end
    end
  end


  get '/app', to: 'root#index'
  get '/app/*path', to: 'root#index'


end
