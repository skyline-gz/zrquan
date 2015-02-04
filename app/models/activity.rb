require "date_utils.rb"
require 'sql_utils'
require 'activity_sql'

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :theme

  def self.sufficient_days
    finished_sql = SqlUtils.escape_sql(ActivitySql::SUFFICIENT_DAYS, current_user.id, 500)
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
