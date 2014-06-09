class Users::RegistrationsController < Devise::RegistrationsController

  # POST /users
  # POST /users.json
  def create
    build_resource(sign_up_params)
		# transaction block for user and user_setting, rollback
		# if one of them failed.
		begin
			ActiveRecord::Base.transaction do
				resource.save!		
				yield resource if block_given?
				@user_setting =	UserSetting.new
				logger.debug("user saved")
				@user_setting.followed_flag = true
				@user_setting.aggred_flag = true
				@user_setting.commented_flag = true
				@user_setting.answer_flag = true
				@user_setting.pm_flag = true
				@user_setting.user_id = resource.id
				@user_setting.save!
			end
			# if transaction succeed.
			if resource.active_for_authentication?
		    set_flash_message :notice, :signed_up if is_flashing_format?
		    sign_up(resource_name, resource)
		    respond_with resource, location: after_sign_up_path_for(resource)
		  else
		    set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
		    expire_data_after_sign_in!
		    respond_with resource, location: after_inactive_sign_up_path_for(resource)
		  end
		# if transaction failed
		rescue => e    
		  clean_up_passwords resource
		  respond_with resource
		end

  end 
       
end
