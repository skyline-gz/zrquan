class HomeController < ApplicationController
	def home
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
end
