require "date_utils.rb"
require 'sql_utils'
require 'question_sql'
require 'post_sql'

class HomeController < ApplicationController
#  before_action :authenticate_user

	# 菜单-首页
	def home
  end

  def hot_posts
    sql = PostSql.home_post_sql("hot")
    sufficient_days = Post.sufficient_days
    if sufficient_days != nil
      recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    else
      # 默认值为最近3个月的动态
      recent = DateUtils.to_yyyymmdd(90.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    end
  end

  def new_posts
    sql = PostSql.home_post_sql("new")
    sufficient_days = Post.sufficient_days
    if sufficient_days != nil
      recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    else
      # 默认值为最近3个月的动态
      recent = DateUtils.to_yyyymmdd(90.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    end
  end

  def hot_questions
    sql = QuestionSql.home_question_sql("hot")
    sufficient_days = Question.sufficient_days
    if sufficient_days != nil
      recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    else
      # 默认值为最近3个月的动态
      recent = DateUtils.to_yyyymmdd(90.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    end
  end

  def new_questions
    sql = QuestionSql.home_question_sql("new")
    sufficient_days = Question.sufficient_days
    if sufficient_days != nil
      recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    else
      # 默认值为最近3个月的动态
      recent = DateUtils.to_yyyymmdd(90.days.ago)
      finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
      ActiveRecord::Base.connection.select_all(finished_sql)
    end
  end

	# 搜索
	def search
		@search = Question.search do
			key_word = params[:search]
			logger.debug("key_word:" + key_word)
			fulltext key_word
		end
		logger.debug(@search.results)
	end

end
