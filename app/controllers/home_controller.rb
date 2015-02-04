require "date_utils.rb"
require 'sql_utils'

class HomeController < ApplicationController
#  before_action :authenticate_user

	# 菜单-首页
	def home
  end

  def hot_posts
    sql = make_post_sql("hot")
    sufficient_days = Post.sufficient_days
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

  def new_posts
    sql = make_post_sql("new")
    sufficient_days = Post.sufficient_days
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

  def hot_questions
    sql = make_question_sql("hot")
    sufficient_days = Question.sufficient_days
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

  def new_questions
    sql = make_question_sql("new")
    sufficient_days = Question.sufficient_days
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

	# 搜索
	def search
		@search = Question.search do
			key_word = params[:search]
			logger.debug("key_word:" + key_word)
			fulltext key_word
		end
		logger.debug(@search.results)
	end

	# 副菜单-我的收藏
	# def my_bookmark
	# 	@bookmarks = current_user.bookmarks
	# end
  #
	# # 副菜单-我的草稿
	# def my_draft
	# end

  private
  def make_question_sql(sort_type)
    select_part =
        "select
          q2.title,
          q2.anonymous_flag,
          q2.created_at,
          q2.answer_count,
          q2.answer_agree,
          q2.follow_count,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          QUESTIONS q2 inner join
          (select
          	 qt.question_id,
          	 min(qt.theme_id) as theme_id
           from
           QUESTION_THEMES qt
           inner join THEME_FOLLOWS tf on (qt.theme_id = tf.theme_id and tf.user_id = ?)
           group by qt.question_id
           order by null
          ) t1 on q2.id = t1.question_id
          inner join USERS u on q2.user_id = u.id
          inner join THEMES t on t1.theme_id = t.id "

    where_part = "where q2.PUBLISH_DATE >= ? "

    order_part = ""
    if sort_type == "hot"
      order_part = "order by q2.hot desc "
    elsif sort_type == "new"
      order_part = "order by q2.created_at desc "
    end

    limit_part = "limit 20"

    select_part + where_part + order_part + limit_part
  end

  def make_post_sql(sort_type)
    select_part =
        "select
            p2.content,
            p2.anonymous_flag,
            p2.created_at,
            p2.agree_score,
            p2.comment_count,
            p2.comment_agree,
            u.name as user_name,
            u.latest_company_name,
            u.latest_position,
            u.latest_school_name,
            u.latest_major,
            u.avatar,
            t.name as theme_name
          from
            POSTS p2 inner join
            (select
               pt.post_id,
               min(pt.theme_id) as theme_id
             from
             POST_THEMES pt
             inner join THEME_FOLLOWS tf on (pt.theme_id = tf.theme_id and tf.user_id = ?)
             group by pt.post_id
             order by null
            ) t1 on p2.id = t1.post_id
            inner join THEMES t on t1.theme_id = t.id
            inner join USERS u on p2.user_id = u.id "

    where_part = "where p2.PUBLISH_DATE >= ? "

    order_part = ""
    if sort_type == "hot"
      order_part = "order by p2.hot desc "
    elsif sort_type == "new"
      order_part = "order by p2.created_at desc "
    end

    limit_part = "limit 20"

    select_part + where_part + order_part + limit_part
  end

end
