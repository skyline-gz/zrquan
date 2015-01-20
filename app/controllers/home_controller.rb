require "date_utils.rb"

class HomeController < ApplicationController
#  before_action :authenticate_user

	# 菜单-首页
	def home
		@rec_users = RecommendUser.all
		@news_feeds = NewsFeed.all
		# 列出最近一个月的个人活动
		prev_month_date = DateUtils.to_yyyymmdd(Date.today.prev_month)
		if current_user != nil
			@recent_activities = Activity.find_by_sql(
				["select A.* from ACTIVITIES A inner join RELATIONSHIPS R on
				 A.USER_ID = R.FOLLOWING_USER_ID and R.FOLLOWER_ID = ? 
				 where A.PUBLISH_DATE >= ? order by A.ID DESC", current_user.id, prev_month_date])
		end
  end

  def posts
    ActiveRecord::Base.connection.select_all(
      ["select
          p2.content,
          p2.anonymous_flag,
          p2.created_at,
          p2.agree_score,
          count(pc.id) as comment_cnt,
          sum(pc.agree_score) as comment_agree,
          u.name as user_name,
          u.avatar,
          t.name as theme_name
        from
          POSTS p2 inner join
          (select p.id, min(tf.theme_id) as theme_id
           from
           POSTS p inner join POST_THEMES pt on p.id = pt.post_id
           inner join THEME_FOLLOWS tf on pt.theme_id = tf.theme_id
           where
           tf.user_id = ?
           group by p.id
          ) t1 on p2.id = t1.id
          inner join POST_COMMENTS pc on p2.id = pc.post_id
          inner join THEMES t on t1.theme_id = t.id
          inner join USERS u on p2.user_id = u.id
        order by p2.hot
        limit 20", current_user.id])
  end

  def questions
    ActiveRecord::Base.connection.select_all(
      ["select
          q2.title,
          q2.anonymous_flag,
          q2.created_at,
          answer_cnt,
          answer_agree,
          u.name as user_name,
          u.avatar,
          t.name as theme_name
        from
          QUESTIONS q2 inner join
          (select
          	 q.id,
          	 min(tf.theme_id) as theme_id,
          	 count(a.id) as answer_cnt,
          	 sum(a.agree_score) as answer_agree
           from
           QUESTIONS q inner join QUESTION_THEMES qt on q.id = qt.question_id
           inner join THEME_FOLLOWS tf on qt.theme_id = tf.theme_id
           inner join ANSWERS a on q.id = a.question_id
           where
           tf.user_id = ?
           group by q.id
          ) t1 on q2.id = t1.id
          inner join THEMES t on t1.theme_id = t.id
          inner join USERS u on q2.user_id = u.id
        order by q2.hot
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
	def my_bookmark
		@bookmarks = current_user.bookmarks
	end

	# 副菜单-我的草稿
	def my_draft
	end
end
