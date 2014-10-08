require "date_utils.rb"

class HomeController < ApplicationController
#  before_action :authenticate_user!

	# 菜单-首页
	def home
		@rec_mentors = RecommendMentor.all
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

	# 菜单-问答
	def question
	end

	# 菜单-经验
	def article
	end

	# 菜单-咨询
	def consult
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
		@draft_articles = current_user.articles.where(draft_flag: true)
	end
end
