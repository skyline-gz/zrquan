require "date_utils.rb"
require 'sql_utils'

class ActivitiesController < ApplicationController
  def list
    user_id = params[:userId]
    activity_id = params[:activityId]

    # 手机下拉刷新,同时获取所有activity_id和最初的20条记录
    if user_id != nil
      sql = ActivitySql::FOLLOWING_ACT_IDS
      sufficient_days = Activity.sufficient_days
      if sufficient_days != nil
        recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
        finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      else
        # 默认值为最近3个月的动态
        recent = DateUtils.to_yyyymmdd(90.days.ago)
        finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      end

      all_id = all_id.map {|ele| ele["id"]}
      finished_sql = SqlUtils.escape_sql(ActivitySql::FOLLOWING_ACTIVITIES, all_id[0..19])
      result = ActiveRecord::Base.connection.select_all(finished_sql)

      render :json => {:ids => all_id, :initial_result => result}

    # 手机上拉刷新,获取对应位置的20条记录
    elsif activity_id != nil
      finished_sql = SqlUtils.escape_sql(ActivitySql::FOLLOWING_ACTIVITIES, activity_id)
      result = ActiveRecord::Base.connection.select_all(finished_sql)
      render :json => {:partial_result => result}
    # 其他情况,错误
    else
      render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR}
    end
  end
end
