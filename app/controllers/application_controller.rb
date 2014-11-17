class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:last_name, :first_name, :email, :password, :password_confirmation) }
  end

  private
  # Session Timeout 或用户点击登出后,应返回首页
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end