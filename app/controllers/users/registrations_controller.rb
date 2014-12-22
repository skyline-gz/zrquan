require "returncode_define.rb"

class Users::RegistrationsController < Devise::RegistrationsController
  # 创建用户（注册）
	# 重写devise的注册controller

  # see: http://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Confirmable
  # sample:
  # curl -v -H 'Content-Type: applicationion/json' -X POST http://localhost:3000/registrations -d "{\"user\":{\"email\":\"yuqi.fan@foxmail.com\",\"password\":\"secret\"}}"
  # {"code":"FA_INVALID_PARAMETERS","msg":{"email":["can't be blank"],"password":["can't be blank"]}}
  # POST /registrations
  def create
    build_resource(sign_up_params)

    # 首先检查用户账号是否已经存在
    user = User.find_by_email(params[:user][:email])
    if user != nil
      render :json => {:code => ReturnCode::FA_USER_ALREADY_EXIT}
      return
    end

    # TODO 异步发送注册邮件，提高注册响应速度　https://github.com/mhfs/devise-async
    resource.skip_confirmation_notification!
    resource_saved = resource.save

    # 此处捕获send email时的异常
    begin
      resource.send_confirmation_instructions
    rescue Net::SMTPAuthenticationError
      # just log and do nothing
      # render :json => {:code => ReturnCode::FA_SMTP_AUTHENTICATION_ERROR}
      logger.error ReturnCode::FA_SMTP_AUTHENTICATION_ERROR
    end

    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_to do |format|
          format.json {render :json => {:code => ReturnCode::S_OK, :redirect => after_sign_up_path_for(resource)}}
          format.html {respond_with resource, location: after_sign_up_path_for(resource)}
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_to do |format|
          format.json {render :json => {:code => ReturnCode::S_INACTIVE_OK, :redirect => after_inactive_sign_up_path_for(resource)}}
          format.html {respond_with resource, location: after_inactive_sign_up_path_for(resource)}
        end
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end

      respond_to do |format|
        format.html{ respond_with resource }
        format.json do render :json => { :code => ReturnCode::FA_INVALID_PARAMETERS, :msg => resource.errors}
        end
      end
    end
  end
       
end
