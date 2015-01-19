require 'return_code'

class Users::AccountController < ApplicationController
  # 验证客户端token是否合法
  # sample:
  # curl -v -H 'Content-Type: applicationion/json' -X POST http://localhost:3000/users/sms_code -d "{\"mobile\":\"13533365535\"}"
  # {"code":"FA_INVALID_PARAMETERS","msg":{"email":["can't be blank"],"password":["can't be blank"]}}
  def verify
    # 生成六位随机数字
    verify_code = '%010d' % rand(10 ** 6)
    # Todo:将verify_code发送到第三方短信平台
    render :json => {:code => ReturnCode::S_OK, :results => verify_code}
  end

  # 登陆账号,返回JWT Token
  def create

  end
end
