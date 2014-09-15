class HomeController < ApplicationController
#  before_action :authenticate_user!

	def home
		@rec_mentors = RecommendMentor.all
		@news_feeds = NewsFeed.all
		if current_user != nil
			@recent_activities = Activity.find_by_sql(
				["select A.* from ACTIVITIES A inner join RELATIONSHIPS R on
				 A.USER_ID = R.FOLLOWING_USER_ID and R.FOLLOWER_ID = ? 
				 where A.RECENT_FLAG = true order by A.ID DESC", current_user.id])
		end
	end

	def search
		@search = Question.search do
			key_word = params[:search]
			logger.debug("key_word:" + key_word)
			fulltext key_word
		end
		logger.debug(@search.results)
	end

	def question
	end

	def article
	end

	def consult
	end

	def my_bookmark
		@bookmarks = current_user.bookmarks
	end

	def my_draft
		@draft_articles = current_user.articles.where(draft_flag: true)
	end
end
