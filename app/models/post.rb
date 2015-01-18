class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_comments
  has_many :agreements, as: :agreeable
  has_many :oppositions, as: :opposable
  has_many :post_themes
  has_many :themes, through: :post_themes
  has_many :bookmarks, as: :bookmarkable

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}
end
