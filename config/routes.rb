Rails.application.routes.draw do
  get 'jwt', to: 'jwt#auth'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        token_validations:  'overrides/token_validations',
        sessions:  'overrides/sessions'
      }
      match 'registry_auth/:method/v2/:namespace/:name/*path', to: 'registry#auth', via: :all
      match 'registry_auth/:method/v1/repositories:namespace/:name/*path', to: 'registry#auth', via: :all
      get 'registry_auth/GET/v2/', to: 'registry#login'
      get 'registry_auth/GET/v1/_ping', to: 'registry#login'

      get '/dashboard', to: 'dashboard#show'
      scope :repos do
        get '/', to: 'repositories#index'
        get '/:namespace', to: 'repositories#index'
        post '', to: 'repositories#create'
        get '/:namespace/:name', to: 'repositories#show'
        put '/:namespace/:name', to: 'repositories#update'
        get '/:namespace/:repository/builds/:id/logs', to: 'builds#logs'
        post '/:namespace/:name/tags/:tag_id/build', to: 'repositories#build'
      end
      resources :namespaces, only: :show
      resources :organizations do
        member do
          get 'show_api_key'
          post 'generate_api_key'
          post 'add_user'
          delete 'remove_user'
        end
      end
      resources :users, only: :show do
        member do
          get 'show_api_key'
          post 'generate_api_key'
        end
        collection do
          get 'names'
        end
      end
      scope :github do
        post '/pushes/:namespace', to: 'github#push'
      end
      resources :builders do
        member do
          post 'request_build'
          post 'update_build'
        end
        collection do
          get 'scripts.tar.gz', to: 'builders#get_scripts'
        end
      end
    end
  end


  get '/', to: 'root#index'
  get '/*path', to: 'root#index'




end
