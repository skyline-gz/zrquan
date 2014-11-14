require "returncode_define.rb"

class Users::SessionsController < Devise::SessionsController

  # usage:
  # curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/sessions -d "{\"user\":{\"email\":\"user@example.com\",\"password\":\"secret\"}}"
  # POST /sessions
  def create
    respond_to do |format|
      format.html{ super }
      format.json do
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        return sign_in_and_redirect(resource_name, resource)
      end
    end
  end

  # DELETE /sessions
  def destroy
    respond_to do |format|
      format.html{ super }
      format.json do
        redirect_path = after_sign_out_path_for(resource_name)
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        code = signed_out ? ReturnCode::S_OK : ReturnCode::FA_UNKNOWN_ERROR
        render :json => {:code => code, :redirect => redirect_path}
      end
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    respond_to do |format|
      format.json {render :json => {:code => ReturnCode::S_OK, :redirect => stored_location_for(scope) || after_sign_in_path_for(resource)}}
      format.html {redirect_to root_url}
    end
  end

  def failure
    user = User.find_by_email(params[:user][:email])
    code = nil
    if user != nil
      user.valid_password?(params[:user][:password]) ? nil : code = ReturnCode::FA_PASSWORD_ERROR
    else
      code = ReturnCode::FA_USER_NOT_EXIT
    end

    respond_to do |format|
      format.json {render :json => {:code => code}}
    end
  end

  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
                      args = no_input.dup.push scope: resource_name
                      warden.authenticate?(*args)
                    else
                      warden.authenticated?(resource_name)
                    end

    if authenticated and resource = warden.user(resource_name)
      respond_to do |format|
        format.html {redirect_to after_sign_in_path_for(resource)}
        # 重复创建session时应提示 用户已登陆
        format.json {render :json => {:code => ReturnCode::FA_SESSION_HAS_BEEN_CREATED, :redirect => after_sign_in_path_for(resource)}}
      end
    end
  end

end
