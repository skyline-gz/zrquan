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
    @industries = Industry.find_by_sql('WITH RECURSIVE q AS (
        SELECT  h, ARRAY[id] AS breadcrumb
        FROM    industries h
        WHERE   parent_industry_id IS NULL
        UNION ALL
        SELECT  hi, breadcrumb || id
        FROM    q
        JOIN    industries hi
        ON      hi.parent_industry_id = (q.h).id
    )
    SELECT  (q.h).id,(q.h).parent_industry_id,(q.h).name,breadcrumb::VARCHAR AS path
    FROM    q
    ORDER BY
    breadcrumb')
  end

  def update_profile
    company = ActionController::Base.helpers.strip_tags params[:company]
    position = ActionController::Base.helpers.strip_tags params[:position]
    region = params[:region].to_i
    location = params[:location].to_i
    industry = params[:industry].to_i
    school = ActionController::Base.helpers.strip_tags params[:school]
    major = ActionController::Base.helpers.strip_tags params[:major]
    if industry != -1
      current_user.industry_id = industry
    end
    if company and company.length > 0
      @company = Company.find_and_save company
      current_user.latest_company_id = @company.id
    end
    if position and position.length > 0
      current_user.latest_position = position
    end
    if region and region != -1 && location
      current_user.location_id = location
    end
    if school and school.length > 0
      @school = School.find_and_save school
      current_user.latest_school_id = @school.id
    end
    if major and major.length > 0
      current_user.latest_major = major
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
    @user_msg_setting = UserMsgSetting.find(current_user.id)
  end

  def user_msg_setting_params
    params.require(:user_msg_setting).permit(:followed_flag, :agreed_flag, :commented_flag, :answer_flag, :pm_flag)
  end
end