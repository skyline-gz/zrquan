require "date_utils.rb"
require 'sql_utils'

class ActivitiesController < ApplicationController
  def list
    # TODO param from android side
    sql = ActivitySql::FOLLOWING_ACTIVITIES
    sufficient_days = Activity.sufficient_days
    if sufficient_days != nil
      recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    else
      # 默认值为最近3个月的动态
      recent = DateUtils.to_yyyymmdd(90.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    end
  end
end
