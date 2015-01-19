require 'return_code'

class Users::AccountController < ApplicationController
  # 验证客户端token是否合法
  # sample:
  # curl -v -H 'Content-Type: applicationion/json' -X GET http://localhost:3000/users/sms_code?mobile=13533365535
  def send_verify_code
    # 生成六位随机数字
    mobile = params[:mobile].to_s
    if /^1[0-9]{10}$/.match(mobile)
      verify_code = VerifyCodeCache.instance.read(mobile)
      unless verify_code
        verify_code = '%6d' % rand(10 ** 6)
      end

      # Todo:将verify_code发送到第三方短信平台，暂时直接将验证码返回以便跳过发短信的步骤
      VerifyCodeCache.instance.write(mobile, verify_code)
      render :json => {:code => ReturnCode::S_OK, :results => verify_code}
    else
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT}
    end
  end

  # curl -v -H 'Content-Type: applicationion/json' -X GET http://localhost:3000/users/sms_code -d "{\"mobile\":\"13533365535\"}"
  # 登陆账号,返回JWT Token
  def create

  end
end
