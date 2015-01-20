require 'return_code'

class Users::SessionController < ApplicationController

  # 验证客户端token是否合法
  def verify

  end

  # curl -v -H 'Content-Type: application/json' -X POST http://localhost:3000/users/session -d "{\"mobile\":\"13533365535\",\"password\":\"12345678\"}"
  # 登陆账号,返回JWT Token
  def create
    mobile = params[:mobile].to_s
    password = params[:password].to_s

    user = User.find_by_mobile(mobile)
    if user.password == password
      give_token
    else
      redirect_to home_url
    end
  end

  private
  def give_token

  end

end