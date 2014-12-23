require 'return_code.rb'

class Users::ConfirmationsController < Devise::ConfirmationsController

  # Ajax重新发送激活信
  # get 'confirmations/resend'
  def resend
    self.resource = resource_class.send_confirmation_instructions({email: current_user.email})
    yield resource if block_given?

    if successfully_sent?(resource)
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR}
    end
  end
end