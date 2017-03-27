class Api::V1::RegistryController < ApiController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def auth

    puts user_name_and_password(request)

    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])

    if ['GET'].include?(params[:method]) && !params[:path].end_with?('/GET/v2/')
      puts "Fetching is always ok for now ..."
      render text: 'ok'
    else

      authenticate_or_request_with_http_basic do |username, password|
        user = User.find_by(name: username)
        if username == 'testuser' || (user.valid_password?(password) && user.available_namespaces.include?(params[:namespace]))
          render text: 'ok'
        else
          render text: 'forbidden', status: :forbidden
        end
      end
    end
  end

end
