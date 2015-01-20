require 'return_code'
require 'regex_expression'

class Users::AccountController < ApplicationController

  # 根据手机号码发送认证短信，并在服务器建立手机号码与验证码的哈希，供注册账号或找回密码使用
  # sample:
  # curl -v -H 'Content-Type: application/json' -X GET http://localhost:3000/users/send_verify_code?mobile=13533365535
  def send_verify_code
    # 生成六位随机数字
    mobile = params[:mobile].to_s
    if RegexExpression::MOBILE.match(mobile)
      verify_code = VerifyCodeCache.instance.read(mobile)
      unless verify_code
        verify_code = rand(100000..999999)
      end

      # Todo:将verify_code发送到第三方短信平台，暂时直接将验证码返回以便跳过发短信的步骤
      VerifyCodeCache.instance.write(mobile, verify_code.to_s)
      render :json => {:code => ReturnCode::S_OK, :results => {:verify_code => verify_code}}
    else
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT}
    end
  end

  # curl -v -H 'Content-Type: application/json' -X GET http://localhost:3000/users/sms_code -d "{\"mobile\":\"13533365535\"}"
  # 重置密码(需要提供验证码)
  def reset_password
    verify_code = params[:verify_code]
  end
end
