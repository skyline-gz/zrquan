class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected
  def authenticate_user
    jwt_token = request.headers['Zrquan-Token']

    if jwt_token == nil
      render :json => {:code => ReturnCode::FA_ACCESS_TOKEN_NOT_EXIT} and return
    end

    begin
      payload = JWT.decode(jwt_token, Settings.jwt.secret)[0]
    rescue JWT::DecodeError
      render :json => {:code => ReturnCode::FA_JWT_SIGNATURE_ERROR} and return
    end

    user = User.find payload['id']
    if user == nil
      render :json => {:code => ReturnCode::FA_USER_NOT_EXIT} and return
    end

    current_sign_in_at = Time.at(payload['current_sign_in_at']).to_datetime
    if current_sign_in_at != user.current_sign_in_at
      render :json => {:code => ReturnCode::FA_SIGN_IN_TIME_INCONSISTENT} and return
    end

    if (Time.now - current_sign_in_at) / 1.days > Settings.jwt.expired_day
      render :json => {:code => ReturnCode::FA_SIGN_IN_TIME_EXPIRED} and return
    end

    @current_user = user
  end

  def current_user
    @current_user ||= authenticate_user
  end
end