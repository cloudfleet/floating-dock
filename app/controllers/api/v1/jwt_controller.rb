class JwtController < ApiController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Basic
  before_action :authenticate_user

  SERVICES = {
    Auth::ContainerRegistryAuthenticationService::AUDIENCE => Auth::ContainerRegistryAuthenticationService,
  }.freeze

  def auth
    service = SERVICES[params[:service]]
    return head :not_found unless service

    result = service.new(@authentication_result.project, @authentication_result.actor, auth_params).
      execute(authentication_abilities: @authentication_result.authentication_abilities)

    render json: result, status: result[:http_status]
  end

  private

  def authenticate_user
    if has_basic_credentials?(request)
      authenticate(*user_name_and_password(request))
    else
      render text: 'ok'
    end
    authenticate_with_http_basic do |login, password|
      @authentication_result = Gitlab::Auth.find_for_git_client(login, password, project: nil, ip: request.ip)

      render_unauthorized unless @authentication_result.success? &&
          (@authentication_result.actor.nil? || @authentication_result.actor.is_a?(User))
    end
  end


  def render_unauthorized
    render json: {
      errors: [
        { code: 'UNAUTHORIZED',
          message: 'HTTP Basic: Access denied' }
      ]
    }, status: 401
  end

  def auth_params
    params.permit(:service, :scope, :account, :client_id)
  end
end
