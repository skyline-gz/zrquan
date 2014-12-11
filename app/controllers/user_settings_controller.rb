require "returncode_define.rb"

class UserSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_msg_setting, only: [:show_notification, :edit_notification]

  # 个人账户设置
  def show_account
  end

  # 密码设置
  def show_password
  end

  # 消息设置
  def show_notification
  end

  def edit_notification
    if @user_msg_setting.update(user_msg_setting_params)
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR, :msg => @user_msg_setting.errors}
    end
  end

  #档案设置
  def show_profile

  end

  def update_profile

  end

  # 获取所有相应id下的所有城市
  def locations
    id = params.id.to_i
  end

  private
  def set_user_msg_setting
    @user_msg_setting = UserMsgSetting.find(current_user.id)
  end

  def user_msg_setting_params
    params.require(:user_msg_setting).permit(:followed_flag, :agreed_flag, :commented_flag, :answer_flag, :pm_flag)
  end
end