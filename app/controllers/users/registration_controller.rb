require 'return_code'
require 'regex_expression'

class Users::RegistrationController < ApplicationController

  # curl -v -H 'Content-Type: application/json' -X POST http://localhost:3000/users/registration -d "{\"mobile\":\"13533365535\",\"password\":\"12345678\",\"name\":\"繁育其\",\"verify_code\":\"123456\"}"
  # 注册用户
  def create
    mobile = params[:mobile].to_s
    verify_code = params[:verify_code].to_s
    password = params[:password].to_s
    name = params[:name]

    if RegexExpression::MOBILE.match(mobile) == nil
      render :json => {:code => ReturnCode::FA_INVALID_MOBILE_FORMAT} and return
    end

    verify_code_in_cache = VerifyCodeCache.instance.read(mobile)
    if verify_code_in_cache == nil
      render :json => {:code => ReturnCode::FA_VERIFY_CODE_EXPIRED} and return
    end

    if verify_code == nil
      render :json => {:code => ReturnCode::FA_NEED_VERIFY_CODE} and return
    end

    if verify_code_in_cache != verify_code
      render :json => {:code => ReturnCode::FA_INVALID_VERIFY_CODE} and return
    end

    user = User.find_by_mobile mobile

    if user
      render :json => {:code => ReturnCode::FA_USER_ALREADY_EXIT} and return
    end

    unless User.password_validate? password
      render :json => {:code => ReturnCode::FA_INVALID_PASSWORD_FORMAT} and return
    end

    user = User.new(:mobile => mobile, :name => name)
    if user.errors[:name].any?
      render :json => {:code => ReturnCode::FA_INVALID_USER_NAME_FORMAT} and return
    end
    user.password = password
    user.save
    render :json => {:code => ReturnCode::S_OK}
  end
end