class Industry < ActiveRecord::Base
  belongs_to :parent_industry
  has_many :users
  has_one :theme, as: :substance

  def all_posts
    theme.all_posts
  end

  def all_questions
    theme.all_questions
  end

  def all_users
    users.order("reputation desc")
  end

  def questions_num
    theme.questions_num
  end

  def posts_num
    theme.questions_num
  end

  def users_num
    users.count
  end
end
