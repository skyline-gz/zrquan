class PostComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :replied_comment
  has_many :aggrements
  has_many :oppositions

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}
end
