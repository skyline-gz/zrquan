class OtherWiki < ActiveRecord::Base
  has_one :theme, as: :substance

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  def posts
    theme.posts
  end

  def questions
    theme.questions
  end
end
