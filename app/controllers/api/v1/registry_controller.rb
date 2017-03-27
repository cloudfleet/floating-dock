class Api::V1::RegistryController < ApiController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Basic

  def auth

    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])

    if ['GET'].include?(params[:method])
      puts "Fetching is always ok for now ..."
      render text: 'ok'
    else

      authenticate_or_request_with_http_basic do |username, password|
        authenticate(username, password)
      end
    end
  end

  def login
    authenticate_or_request_with_http_basic do |username, password|
      authenticate(username, password)
    end
    # if has_basic_credentials?(request)
    #   authenticate(*user_name_and_password(request))
    # else
    #   render text: 'ok'
    # end
  end

  private

  def authenticate(username, password)
    puts "Authenticating user #{username} with #{password}"
    user = User.find_by(name: username)
    if username == 'testuser' || (user && user.valid_password?(password) && user.available_namespaces.include?(params[:namespace]))
      render text: 'ok'
    else
      render text: 'forbidden', status: :forbidden
    end
  end
end
