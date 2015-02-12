require "date_utils.rb"
require 'sql_utils'
require 'question_sql'
require 'post_sql'

class HomeController < ApplicationController
#  before_action :authenticate_user

	# 菜单-首页
	def home
  end

  def posts
    user_id = params[:userId]
    post_id = params[:postId]
    sort_type = params[:sortType]

    # 手机下拉刷新,同时获取所有post_id和最初的20条记录
    if user_id != nil
      sql = PostSql.home_post_ids(sort_type)
      sufficient_days = 90
      # sufficient_days = Post.sufficient_days

      if sufficient_days != nil
        recent = sufficient_days.days.ago.strftime("%Y-%m-%d")
        finished_sql = SqlUtils.escape_sql(sql, user_id.to_i, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      else
        # 默认值为最近3个月的动态
        recent = 90.days.ago.strftime("%Y-%m-%d")
        finished_sql = SqlUtils.escape_sql(sql, user_id.to_i, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      end

      all_id = all_id.map {|ele| ele["post_id"]}
      finished_sql = SqlUtils.escape_sql(PostSql::HOME_POST_SQL, all_id[0..19])
      result = ActiveRecord::Base.connection.select_all(finished_sql)

      render :json => {:ids => all_id, :initial_result => result}

    # 手机上拉刷新,获取对应位置的20条记录
    elsif post_id != nil
      finished_sql = SqlUtils.escape_sql(PostSql::HOME_POST_SQL, post_id)
      result = ActiveRecord::Base.connection.select_all(finished_sql)
      render :json => {:partial_result => result}
    # 其他情况,错误
    else
      render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR}
    end
  end

  # def hot_posts
  #   # user_id = current_user.id
  #   user_id = params[:userId]
  #   page = params[:page].to_i
  #   sql = PostSql.home_post_sql("hot", page)
  #   # sufficient_days = Post.sufficient_days
  #   sufficient_days = 90
  #   result = nil
  #   if sufficient_days != nil
  #     recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
  #     finished_sql = SqlUtils.escape_sql(sql, user_id, recent)
  #     result = ActiveRecord::Base.connection.select_all(finished_sql)
  #   else
  #     # 默认值为最近3个月的动态
  #     recent = DateUtils.to_yyyymmdd(90.days.ago)
  #     finished_sql = SqlUtils.escape_sql(sql, user_id, recent)
  #     result = ActiveRecord::Base.connection.select_all(finished_sql)
  #   end
  #
  #   render :json => {:result => result}
  #   # render 'home/hot_posts'
  # end

  def questions
    user_id = params[:userId]
    question_id = params[:questionId]
    sort_type = params[:sortType]

    # 手机下拉刷新,同时获取所有post_id和最初的20条记录
    if user_id != nil
      sql = QuestionSql.home_question_ids(sort_type)
      sufficient_days = Question.sufficient_days
      if sufficient_days != nil
        recent = sufficient_days.days.ago.strftime("%Y-%m-%d")
        finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      else
        # 默认值为最近3个月的动态
        recent = 90.days.ago.strftime("%Y-%m-%d")
        finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
        all_id = ActiveRecord::Base.connection.select_all(finished_sql)
      end

      all_id = all_id.map {|ele| ele["question_id"]}
      finished_sql = SqlUtils.escape_sql(QuestionSql::HOME_QUESTION_SQL, all_id[0..19])
      result = ActiveRecord::Base.connection.select_all(finished_sql)

      render :json => {:ids => all_id, :initial_result => result}

    # 手机上拉刷新,获取对应位置的20条记录
    elsif question_id != nil
      finished_sql = SqlUtils.escape_sql(QuestionSql::HOME_QUESTION_SQL, question_id)
      result = ActiveRecord::Base.connection.select_all(finished_sql)
      render :json => {:partial_result => result}
    # 其他情况,错误
    else
      render :json => {:code => ReturnCode::FA_UNKNOWN_ERROR}
    end

  end

  # def new_questions
  #   sql = QuestionSql.home_question_sql("new")
  #   sufficient_days = Question.sufficient_days
  #   if sufficient_days != nil
  #     recent = DateUtils.to_yyyymmdd(sufficient_days.days.ago)
  #     finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
  #     ActiveRecord::Base.connection.select_all(finished_sql)
  #   else
  #     # 默认值为最近3个月的动态
  #     recent = DateUtils.to_yyyymmdd(90.days.ago)
  #     finished_sql = SqlUtils.escape_sql(sql, current_user.id, recent)
  #     ActiveRecord::Base.connection.select_all(finished_sql)
  #   end
  # end

	# 搜索
	def search
		@search = Question.search do
			key_word = params[:search]
			logger.debug("key_word:" + key_word)
			fulltext key_word
		end
		logger.debug(@search.results)
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_params
    params.require(:answer).permit(:content)
  end

end
