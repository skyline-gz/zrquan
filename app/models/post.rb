class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_comments
  has_many :aggrements
  has_many :oppositions
  has_many :post_themes
  has_many :themes, through: :post_themes

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}
end
