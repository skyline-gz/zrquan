require "date_utils.rb"

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :theme

  def self.sufficient_days
    finished_sql = SqlUtils.escape_sql(
        "select min(recent_days) as recent_days
        from following_act_stats fas
        where fas.user_id = ? and fas.following_act_count >= ?", current_user.id, 500)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["recent_days"]
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
