class Article < ActiveRecord::Base
  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :bookmarks, as: :bookmarkable
	has_many :comments, as: :commentable
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	has_many :agreements, as: :agreeable

	validates :title, :content, :theme, presence: true

	# for test
	def output_title
		logger.debug(self.title)
	end
end
