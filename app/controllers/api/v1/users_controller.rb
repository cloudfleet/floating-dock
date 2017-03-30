class Api::V1::UsersController < ApiController
  before_action :authenticate_api_v1_user!
  load_and_authorize_resource

  def show
    render json: @user
  end

  def show_api_key
    render json: {api_key: @user.api_key}
  end

  def generate_api_key
    @user.api_key =  (0..32).map { ('a'..'z').to_a[rand(26)] }.join
    @user.save!
    render json: {result: 'success'}
  end

  def names
    render json: User.select(:name).map(&:name)
  end

  private

  def user_params
    params.require(:name)
  end



end
