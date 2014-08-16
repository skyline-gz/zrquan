class HomeController < ApplicationController
#  before_action :authenticate_user!

	def home
		@rec_mentors = RecommendMentor.all
		@news_feeds = NewsFeed.all
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
