class Article < ActiveRecord::Base
  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :bookmarks, as: :bookmarkable
	has_many :comments, as: :commentable

	# for test
	def output_title
		logger.debug(self.title)
	end
end
