require "date_utils.rb"

class ActivitiesController < ApplicationController
  def list
    sql = make_sql(param_enough)   # TODO param from android side
    recent = DateUtils.to_yyyymmdd(3.months.ago)
    if param_enough
      ActiveRecord::Base.connection.select_all(
          [sql, current_user.id, recent])
    else
      ActiveRecord::Base.connection.select_all(
          [sql, current_user.id])
    end
  end

  private
  def make_sql(is_recent_enough)
    select_part =
        "select
          a.activity_type,
          u.name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          case a.target_type
            when 'Question' then q.title
            when 'Answer' then an.content
            when 'Post' then p.content
            when 'PostComment' then pc.content
          end main_content,
          case a.target_type
            when 'Question' then q.answer_count
            when 'Answer' then q2.answer_count
            when 'Post' then p.comment_count
            when 'PostComment' then p2.comment_count
          end count_1,
          case a.target_type
            when 'Question' then q.follow_count
            when 'Answer' then q2.follow_count
            when 'Post' then p.agree_score
            when 'PostComment' then p2.agree_score
          end count_2,
          case a.target_type
            when 'Question' then q.follow_count
            when 'Answer' then q2.follow_count
            when 'Post' then p.agree_score
            when 'PostComment' then p2.agree_score
          end count_2,
          case a.target_type
            when 'Question' then q.answer_agree
            when 'Answer' then q2.answer_agree
            when 'Post' then p.comment_agree
            when 'PostComment' then p2.comment_agree
          end 2nd_content_agree,
          case a.target_type
            when 'Question' then q.created_at
            when 'Answer' then an.created_at
            when 'Post' then p.created_at
            when 'PostComment' then pc.created_at
          end created_at,
          case a.target_type
            when 'Question' then null
            when 'Answer' then q2.title
            when 'Post' then null
            when 'PostComment' then p2.content
          end sub_content
          from ACTIVITIES a force index(index_activities_on_user_id_and_publish_date)
          inner join RELATIONSHIPS r on (r.FOLLOWER_ID = ? and a.USER_ID = r.FOLLOWING_USER_ID)
          inner join USERS u on (r.FOLLOWING_USER_ID = u.id)
          left join questions q on (a.target_id = q.id and a.target_type = 'Question' and q.anonymous_flag = 0)
          left join answers an on (a.target_id = an.id and a.target_type = 'Answer' and an.anonymous_flag = 0)
          left join questions q2 on (a.sub_target_id = q2.id and a.sub_target_type = 'Question')
          left join posts p on (a.target_id = p.id and a.target_type = 'Post' and p.anonymous_flag = 0)
          left join post_comments pc on (a.target_id = pc.id and a.target_type = 'PostComment' and pc.anonymous_flag = 0)
          left join posts p2 on (a.sub_target_id = p2.id and a.sub_target_type = 'Post') "

    where_part = "where a.PUBLISH_DATE >= ? "

    order_part = "order by a.PUBLISH_DATE DESC "

    is_recent_enough ? (select_part + where_part + order_part) : (select_part + order_part)
  end
end
