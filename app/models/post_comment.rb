class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :replied_comment
  has_many :agreements, as: :agreeable
  has_many :oppositions, as: :opposable

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}
end
