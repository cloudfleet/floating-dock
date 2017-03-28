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
      current_user
    end
  end


  def auth_params
    params.permit(:service, :scope, :account, :client_id)
  end
end
