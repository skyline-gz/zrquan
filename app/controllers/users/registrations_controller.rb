require "returncode_define.rb"

class Users::RegistrationsController < Devise::RegistrationsController
  # 创建用户（注册）
	# 重写devise的注册controller

  # sample:
  # curl -v -H 'Content-Type: applicationion/json' -X POST http://localhost:3000/registrations -d "{\"user\":{\"email\":\"yuqi.fan@foxmail.com\",\"password\":\"secret\"}}"
  # {"code":"FA_INVALID_PARAMETERS","msg":{"email":["can't be blank"],"password":["can't be blank"]}}
  # POST /registrations
  def create
    build_resource(sign_up_params)

    # 此处捕获devise save时的异常,并返回JSON到前端
    begin
      resource_saved = resource.save
    rescue Net::SMTPAuthenticationError
      render :json => {:code => ReturnCode::FA_SMTP_AUTHENTICATION_ERROR}
      return
    end

    yield resource if block_given?
    if resource_saved
			# TODO if user_setting cannot be saved, set error message to the log
			@user_setting =	UserSetting.new
			@user_setting.user_id = resource.id
			@user_setting.save!
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
