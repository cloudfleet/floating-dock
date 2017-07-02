module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      render json: {
        data: UserSerializer.new(@resource, scope: @resource).as_json,
        success: true
      }
    end
  end
end
