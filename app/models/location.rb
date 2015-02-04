class Location < ActiveRecord::Base
  belongs_to :region
  has_one :theme, as: :substance
  has_many :users

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
