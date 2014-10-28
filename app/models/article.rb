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
	validates :title, length: {in: 8..50}
	validates :content, length: {in: 100..20000}


  def draft?
    draft_flag
  end
end
