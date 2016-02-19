class Api::V1::UsersController < ApiController
  before_action :authenticate_api_v1_user!
  load_and_authorize_resource

  def show
    render json: @user
  end

  def user_params
    params.require(:name)
  end

end
