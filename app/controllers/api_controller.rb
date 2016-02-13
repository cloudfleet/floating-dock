class ApiController < ActionController::API
  include ActionController::Serialization
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'access-token, expiry, token-type, Origin, Content-Type, Accept, Authorization, Token, X-TREATS-AUTH-KEY'
    headers['Access-Control-Expose-Headers'] = 'access-token, expiry, token-type'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'access-token, expiry, token-type, X-Requested-With, X-Prototype-Version, Token, Content-Type, Accept, X-TREATS-AUTH-KEY'
      headers['Access-Control-Expose-Headers'] = 'access-token, expiry, token-type'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def options

  end

end
