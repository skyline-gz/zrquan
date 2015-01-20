class ActivitiesController < ApplicationController
  def list
    prev_month_date = DateUtils.to_yyyymmdd(Date.today.prev_month)
    if current_user != nil
    	@recent_activities = Activity.find_by_sql(
    		["select A.* from ACTIVITIES A inner join RELATIONSHIPS R on
    		 A.USER_ID = R.FOLLOWING_USER_ID and R.FOLLOWER_ID = ?
    		 where A.PUBLISH_DATE >= ? order by A.ID DESC", current_user.id, prev_month_date])
    end
  end
end
