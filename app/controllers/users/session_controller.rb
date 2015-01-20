require 'return_code'
require 'regex_expression'

class Users::SessionController < ApplicationController

  # curl -v -H 'Content-Type: application/json' -H 'Zrquan-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50X3NpZ25faW5fYXQiOjE0MjE3NDIyMzAsImlkIjoyfQ.HYwm4BYzocGwWHrWGnVI7HwlG9RXCqj3BpoPAdja-l8' -X GET http://localhost:3000/users/verify
  # 验证客户端token是否合法
  def verify
    jwt_token = request.headers['Zrquan-Token']
    begin
      payload = JWT.decode(jwt_token, Settings.jwt.secret)[0]
    rescue JWT::DecodeError
      render :json => {:code => ReturnCode::FA_JWT_SIGNATURE_ERROR}
    end

    user = User.find payload['id']
    if user == nil
      render :json => {:code => ReturnCode::FA_USER_NOT_EXIT}
    end

    current_sign_in_at = Time.at(payload['current_sign_in_at']).to_datetime
    if current_sign_in_at != user.current_sign_in_at
      render :json => {:code => ReturnCode::FA_SIGN_IN_TIME_INCONSISTENT}
    end

    if (Time.now - current_sign_in_at) / 1.days > Settings.jwt.expired_day
      render :json => {:code => ReturnCode::FA_SIGN_IN_TIME_EXPIRED}
    end

    render :json => {:code => ReturnCode::S_OK}
  end

  # curl -v -H 'Content-Type: application/json' -X POST http://localhost:3000/users/session -d "{\"mobile\":\"13533365535\",\"password\":\"12345678\"}"
  # 登陆账号,返回JWT Token
  def create
    mobile = params[:mobile].to_s
    password = params[:password].to_s

    if RegexExpression::MOBILE.match(mobile) == nil
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT}
    end

    if RegexExpression::PASSWORD.match(password) == nil
      render :json => {:code => ReturnCode::FA_INVALID_PASSWORD_FORMAT} and return
    end

    user = User.find_by_mobile(mobile)

    if user == nil
      render :json => {:code => ReturnCode::FA_USER_NOT_EXIT} and return
    end

    if user.password == password
      user.current_sign_in_at = Time.now
      user.save
      jwt_token = give_token(user.id, user.current_sign_in_at)
      render :json => {:code => ReturnCode::S_OK, :results => {:token => jwt_token}}
    else
      render :json => {:code => ReturnCode::FA_PASSWORD_ERROR} and return
    end
  end

  private
  def give_token (uid, time)
    JWT.encode({:current_sign_in_at => time.to_i, :id => uid}, Settings.jwt.secret)
  end

end