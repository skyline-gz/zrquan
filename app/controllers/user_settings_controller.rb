class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  # 个人账户设置
  def show_account

  end

  # 密码设置
  def show_password

  end

  # 消息设置
  def show_notification

  end
end