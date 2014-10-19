class Users::RegistrationsController < Devise::RegistrationsController
  # 创建用户（注册）
	# 重写devise的注册controller

  # sample:
  # curl -v -H 'Content-Type: applicationion/json' -X POST http://localhost:3000/users -d "{\"user\":{\"email\":\"yuqi.fan@foxmail.com\",\"password\":\"secret\"}}"
  # {"code":"FA_INVALID_PARAMETERS","info":{"email":["can't be blank"],"password":["can't be blank"]}}
  # POST /resource/sign_in
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
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
          format.json {render :json => {:code => "S_OK", :redirect => after_sign_up_path_for(resource)}}
          format.html {respond_with resource, location: after_sign_up_path_for(resource)}
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_to do |format|
          format.json {render :json => {:code => "S_INACTIVE_OK", :redirect => after_inactive_sign_up_path_for(resource)}}
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
        format.json do render :json => { :code => "FA_INVALID_PARAMETERS", :msg => resource.errors}
        end
      end
    end
  end
       
end
