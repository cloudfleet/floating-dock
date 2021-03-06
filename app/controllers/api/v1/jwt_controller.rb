class JwtController < ApiController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Basic
  # before_action :authenticate_user

  SERVICES = {
    Auth::ContainerRegistryAuthenticationService::AUDIENCE => Auth::ContainerRegistryAuthenticationService,
  }.freeze

  def auth
    service = SERVICES[params[:service]]
    return head :not_found unless service

    result = service.new(try_authenticate_user, auth_params).execute

    render json: result, status: result[:http_status]
  end

  private

  def try_authenticate_user
    if has_basic_credentials?(request)
      authenticate(*user_name_and_password(request))
    end
  end

  def authenticate(username, password)

    if (user = User.find_by(name: username) || User.find_by(email: username)) && user.valid_password?(password)
      user
    elsif (builder = Builder.find(username)) && password == builder.auth_key
      builder
    end

  end



  def auth_params
    params.permit(:service, :scope, :account, :client_id)
  end
end
