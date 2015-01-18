class Industry < ActiveRecord::Base
  belongs_to :parent_industry
  has_many :users
  has_one :theme, as: :substance

  def posts
    theme.posts
  end

  def questions
    theme.questions
  end
end
