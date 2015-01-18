class Location < ActiveRecord::Base
  belongs_to :region
  has_many :users

  def posts
    theme.posts
  end

  def questions
    theme.questions
  end
end
