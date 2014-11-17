require "returncode_define.rb"

class Users::PasswordsController < Devise::PasswordsController

  # 支持Ajax修改密码
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_to do |format|
        format.json {render :json => {:code => ReturnCode::S_OK, :redirect => after_sending_reset_password_instructions_path_for(resource_name)}}
        format.html {respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))}
      end
    else
      respond_to do |format|
        format.json {render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR}}
        format.html {respond_with(resource)}
      end
    end
  end

  # 重写此方法只为了改变layout为full_middle.html.erb
  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render layout: "full_middle"
  end

  protected
    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      root_url
    end
end