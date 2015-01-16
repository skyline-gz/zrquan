class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :replied_comment

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}
end
