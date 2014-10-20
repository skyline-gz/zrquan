class Article < ActiveRecord::Base
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :bookmarks, as: :bookmarkable
	has_many :comments, as: :commentable
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	has_many :agreements, as: :agreeable
	has_many :article_themes
  accepts_nested_attributes_for :article_themes

	validates :title, :content, presence: true, on: :create

	# for test
	def output_title
		logger.debug(self.title)
	end
end
