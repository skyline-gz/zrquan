class Users::SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    respond_to do |format|
      format.html{ super }
      format.json do
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        return sign_in_and_redirect(resource_name, resource)
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    respond_to do |format|
      format.html{ super }
      format.json do
        redirect_path = after_sign_out_path_for(resource_name)
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        code = signed_out ? "S_OK" : "FA_UNKNOWN_ERROR";
        render :json => {:code => code, :redirect => redirect_path}
      end
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    respond_to do |format|
      format.json {render :json => {:code => "S_OK", :redirect => stored_location_for(scope) || after_sign_in_path_for(resource)}}
      format.html {redirect_to root_url}
    end
  end

  def failure
    user = User.find_by_email(params[:user][:email])
    code = nil
    if user != nil
      user.valid_password?(params[:user][:password]) ? code : code = "FA_PASSWORD_ERROR"
    else
      code = "FA_USAR_NOT_EXIT"
    end

    respond_to do |format|
      format.json {render :json => {:code => code}}
    end
  end

end