require "date_utils.rb"

class CommentsController < ApplicationController
  include ReturnCode
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # 列举评论
  def show

  end

  # 创建
  def create
    # 问题评论
    if params[:question_id] != nil
      @question = Question.find(params[:question_id])
      authorize! :comment, @question
      # 创建经验评论
      @comment = current_user.comments.new(comment_params)
      @comment.commentable_id = params[:question_id]
      @comment.commentable_type = "Question"
      @comment.replied_comment_id = params[:replied_comment_id]
      @comment.save!
      # 创建消息并发送
      if current_user.user_msg_setting.commented_flag
        @article.user.messages.create!(msg_type: 3, extra_info1_id: current_user.id, extra_info1_type: "User",
                                       extra_info2_id: @article.id, extra_info2_type: "Question")
        # TODO 发送到faye
      end
      # 创建用户行为（评论经验）
      current_user.activities.create!(target_id: @article.id, target_type: "Question", activity_type: 4,
                                      publish_date: DateUtils.to_yyyymmdd(Date.today))
      redirect_to article_path(@question), notice: 'Comment was successfully created.'
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
      @comment.replied_comment_id = params[:replied_comment_id]
			@comment.save!
			# 创建消息并发送
			if current_user.user_msg_setting.commented_flag
				@answer.user.messages.create!(msg_type: 2, extra_info1_id: current_user.id, extra_info1_type: "User",
                                       extra_info2_id: @question.id, extra_info2_type: "Question")
			end
			# 创建用户行为（评论答案）
			current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 3,
																		  publish_date: DateUtils.to_yyyymmdd(Date.today))
      render :json => {:code => S_OK}
		end
  end

  # 删除评论
  def destroy

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
