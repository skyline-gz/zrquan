require 'return_code'

class Users::SessionController < ApplicationController

  # 根据手机号码发送认证短信，并在服务器建立手机号码与验证码的哈希，供注册账号或找回密码使用
  def send_verify_code

  end

  # 更改密码
  def change_password
    verify_code = params[:verify_code]
  end

end