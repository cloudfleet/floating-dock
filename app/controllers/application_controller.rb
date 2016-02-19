class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_api_v1_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
