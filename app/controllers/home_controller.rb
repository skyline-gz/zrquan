require "date_utils.rb"

class HomeController < ApplicationController
#  before_action :authenticate_user

	# 菜单-首页
	def home
  end

  def hot_posts
    ActiveRecord::Base.connection.select_all(
      ["select
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
          inner join USERS u on p2.user_id = u.id
        order by p2.hot desc
        limit 20", current_user.id])
  end

  def new_posts
    ActiveRecord::Base.connection.select_all(
        ["select
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
            inner join USERS u on p2.user_id = u.id
          order by p2.publish_date desc
          limit 20", current_user.id])
  end

  def hot_questions
    ActiveRecord::Base.connection.select_all(
      ["select
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
          inner join THEMES t on t1.theme_id = t.id
		    order by q2.hot desc
        limit 20", current_user.id])
  end

  def new_questions
    ActiveRecord::Base.connection.select_all(
        ["select
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
            inner join THEMES t on t1.theme_id = t.id
          order by q2.publish_date desc
          limit 20", current_user.id])
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
end
