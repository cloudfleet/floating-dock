class Api::V1::RegistryController < ApiController

  def auth
    @repository = Repository.find_by(owner_name: params[:namespace], name: params[:name])

    if request.get?
      puts "Fetching is always ok for now ..."
      render text: 'ok'
    else

      authenticate_or_request_with_http_basic(realm: 'marina.io'){ |username, password|
        user = User.find_by(name: username)
        if user.valid_password?(password) && user.available_namespaces.include?(params[:namespace])
          render text: 'ok'
        end
      }
    end
  end

end
