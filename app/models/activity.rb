require "date_utils.rb"

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :theme

  def self.recent_count_enough?
    recent = DateUtils.to_yyyymmdd(3.months.ago)
    result = ActiveRecord::Base.connection.select_all(
        ["select count(a.id) as recent_count
          from ACTIVITIES a inner join RELATIONSHIPS r on (r.FOLLOWER_ID = ? and a.USER_ID = r.FOLLOWING_USER_ID)
          where a.publish_date >= ?", current_user.id, recent]
    )
    result[0]["recent_count"] >= 500
  end

	def pdate_to_s
		Date.parse(publish_date.to_s)
	end

	def ask_question?
		activity_type == 1
	end

	def answer_question?
		activity_type == 2
	end


end
