class ConsultSubject < ActiveRecord::Base
  belongs_to :mentor, class_name: "User"
  belongs_to :apprentice, class_name: "User"
	has_many :consult_replies
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	has_many :consult_themes
	accepts_nested_attributes_for :mentor
  accepts_nested_attributes_for :consult_themes

	validates :title, presence: true, on: :create
	validates :title, length: {in: 8..50}
	validates :content, length: {maximum: 10000}

  # 结束状态
  def closed?
    stat_class == 3
  end

  # 进行中状态
  def in_progress?
    stat_class == 2
  end

  # 被忽略状态
  def ignored?
    stat_class == 4
  end

  # 申请中状态
  def applying
    stat_class == 1
  end
end
