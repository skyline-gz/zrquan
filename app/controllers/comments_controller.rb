require "date_utils.rb"

class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # 列表
  def index
    @comments = Comment.all
  end

  # 新建评论对象
  def new
    @comment = Comment.new
  end

  # 创建
  def create
		# 经验评论
		if params[:article_id] != nil
			@article = Article.find(params[:article_id])
      authorize! :comment, @article
			# 创建经验评论
		  @comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:article_id]
			@comment.commentable_type = "Article"
			@comment.save!
			# 创建消息并发送
			if current_user.user_setting.commented_flag == true
				@article.user.messages.create!(msg_type: 3, extra_info1_id: current_user.id, extra_info1_type: "User",
                                       extra_info2_id: @article.id, extra_info2_type: "Article")
				# TODO 发送到faye
			end
			# 创建用户行为（评论经验）
			current_user.activities.create!(target_id: @article.id, target_type: "Article", activity_type: 4,
																		  publish_date: DateUtils.to_yyyymmdd(Date.today))
		  redirect_to article_path(@article), notice: 'Comment was successfully created.'
		end
		# 答案评论
		if params[:answer_id] != nil
			@answer = Answer.find(params[:answer_id])
      authorize! :comment, @answer
			@question = @answer.question
			# 创建答案评论
			@comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:answer_id]
			@comment.commentable_type = "Answer"
			@comment.save!
			# 创建消息并发送
			if current_user.user_setting.commented_flag == true
				@answer.user.messages.create!(msg_type: 2, extra_info1_id: current_user.id, extra_info1_type: "User",
                                       extra_info2_id: @question.id, extra_info2_type: "Question")
			end
			# 创建用户行为（评论答案）
			current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 3,
																		  publish_date: DateUtils.to_yyyymmdd(Date.today))
		  redirect_to question_path(@question), notice: 'Comment was successfully created.'
		end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end		
end
