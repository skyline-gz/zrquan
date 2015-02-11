require 'return_code'
require 'regex_expression'

class Users::AccountController < ApplicationController

  # 根据手机号码发送认证短信，并在服务器建立手机号码与验证码的哈希，供注册账号或找回密码使用
  # param: mobile 欲发送确认短信的手机号
  # 　　　　ignore_mobile_check  是否跳过检测已注册的手机号(用于找回密码)
  # sample:
  # curl -v -H 'Content-Type: application/json' -X GET http://localhost:3000/users/send_verify_code?mobile=13533365535&ignore_mobile_check=true
  def send_verify_code
    # 生成六位随机数字
    mobile = (params[:mobile] || '').to_s
    ignore_mobile_check = (params[:ignore_mobile_check]) == 'true'
    if RegexExpression::MOBILE.match(mobile)
      unless ignore_mobile_check
        user = User.find_by_mobile mobile
        if user
          render :json => {:code => ReturnCode::FA_USER_ALREADY_EXIT} and return
        end
      end

      verify_code = VerifyCodeCache.instance.read(mobile)
      unless verify_code
        verify_code = rand(100000..999999).to_s
      end

      # Todo:将verify_code发送到第三方短信平台，暂时直接将验证码返回以便跳过发短信的步骤
      VerifyCodeCache.instance.write(mobile, verify_code)
      render :json => {:code => ReturnCode::S_OK, :results => {:verify_code => verify_code}}
    else
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT}
    end
  end

  # curl -v -H 'Content-Type: application/json' -X POST http://localhost:3000/users/reset_password -d "{\"mobile\":\"13533365535\"}"
  # 重置密码(需要提供验证码)
  def reset_password
    mobile = (params[:mobile] || '').to_s
    verify_code = (params[:verify_code] || '').to_s
    new_password = (params[:new_password] || '').to_s

    if verify_code == nil || verify_code.length == 0
      render :json => {:code => ReturnCode::FA_NEED_VERIFY_CODE} and return
    end

    verify_code_in_cache = VerifyCodeCache.instance.read(mobile)
    if verify_code_in_cache == nil
      render :json => {:code => ReturnCode::FA_VERIFY_CODE_EXPIRED} and return
    end

    unless RegexExpression::MOBILE.match(mobile)
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT}
    end

    unless User.password_validate? new_password
      render :json => {:code => ReturnCode::FA_INVALID_PASSWORD_FORMAT} and return
    end

    user = User.find_by_mobile mobile

    unless user
      render :json => {:code => ReturnCode::FA_USER_NOT_EXIT} and return
    end

    user.password = new_password
    user.save
    render :json => {:code => ReturnCode::S_OK}
  end
end
