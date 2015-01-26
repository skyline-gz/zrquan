require "return_code.rb"

class UserSettingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user_msg_setting, only: [:show_notification, :edit_notification]

  # 个人账户设置
  def show_account
  end

  # 密码设置
  def show_password
  end

  # 个人设置，更改密码
  def update_password
    if params[:password] != params[:password_confirmation]
      render :json => {:code => ReturnCode::FA_PASSWORD_INCONSISTENT}
    end
    @user = User.find(current_user.id)
    if @user.update_with_password(user_update_password_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_PASSWORD_ERROR}
    end
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
    @is_female = false
    if defined? current_user.gender and current_user.gender == 0
      @is_female = true
    end
    @company = Company.new
    if current_user.latest_company_id
      @company = Company.find current_user.latest_company_id
    end
    @school = School.new
    if current_user.latest_school_id
      @school = School.find current_user.latest_school_id
    end
    if current_user.location_id
      @region_id = Location.find(current_user.location_id).region_id
      @locations = Location.where ({:region_id => @region_id})
    end

    # 换成mysql和pg通用的sql
    @industries = Industry.find_by_sql('
      select id, name, parent_industry_id
      from industries
      order by
      case
        when parent_industry_id is null then id
        when parent_industry_id is not null then parent_industry_id
      end,
      case
        when parent_industry_id is null then 0
        when parent_industry_id is not null then 1
      end, id')
  end

  def update_profile
    region = params[:region].to_i
    location = params[:location].to_i
    industry = params[:industry].to_i
    gender = params[:gender].to_i
    description = ActionController::Base.helpers.strip_tags params[:description]

    current_user.gender = gender
    if industry != -1
      current_user.industry_id = industry
    end
    if region and region != -1 && location
      current_user.location_id = location
    end
    if description.length > 0
      current_user.description = description
    end
    current_user.save
    render :json => {:code => ReturnCode::S_OK}
  end

  # 获取所有相应id下的所有城市
  def locations
    id = params[:id]
    if id
      @locations = Location.where ({:region_id => id.to_i})
      render 'show_locations'
    else
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
    end
  end

  private
  def set_user_msg_setting
    @user_msg_setting = current_user.user_msg_setting
  end

  def user_msg_setting_params
    params.require(:user_msg_setting).permit(:followed_flag, :agreed_flag, :commented_flag, :answer_flag, :pm_flag)
  end

  def user_update_password_params
    params.permit(:current_password, :password, :password_confirmation)
  end
end