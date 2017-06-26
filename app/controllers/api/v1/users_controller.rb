class Api::V1::UsersController < ApiController
  before_action :authenticate_api_v1_user!
  load_and_authorize_resource

  def show
    render json: @user
  end

  def show_api_key
    unless @user.api_key
      @user.api_key =  (0..32).map { ('a'..'z').to_a[rand(26)] }.join
      @user.save!
    end
    render json: {api_key: @user.api_key}
  end

  def generate_api_key
    @user.api_key =  (0..32).map { ('a'..'z').to_a[rand(26)] }.join
    @user.save!
    render json: {result: 'success'}
  end

  def names
    fragment = params[:query]
    if fragment && fragment.length >= 2
      render json: User.select(:name).map(&:name).select{|name| name.downcase.start_with? fragment.downcase}
    else
      render json: []
    end
  end

  private

  def user_params
    params.require(:name)
  end



end
