class Certification < ActiveRecord::Base
  has_one :theme, as: :substance

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  def all_posts
    theme.all_posts
  end

  def all_questions
    theme.all_questions
  end

  def questions_num
    theme.questions_num
  end

  def posts_num
    theme.questions_num
  end
end
