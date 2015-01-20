require 'return_code'
require 'regex_expression'

class Users::SessionController < ApplicationController

  # 验证客户端token是否合法
  def verify

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
      jwt_token = give_token user.id
      render :json => {:code => ReturnCode::S_OK, :results => {:token => jwt_token}}
    else
      render :json => {:code => ReturnCode::FA_PASSWORD_ERROR} and return
    end
  end

  private
  def give_token (uid)
    JWT.encode({:current_login_at => Time.now.to_i(), :id => uid}, Settings.jwt_secret)
  end

end