class CommentsController < ApplicationController
  include DateUtils
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
			# 创建经验评论
		  @comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:article_id]
			@comment.commentable_type = "Article"
			@comment.save!
			# 创建消息并发送
			if current_user.user_setting.commented_flag == true
				msg_content = "New comment for your article: " + @article.title + "."
				@article.user.messages.create!(content: msg_content, msg_type: 1)
				# TODO 发送到faye
			end
			# 创建用户行为（评论经验）
			current_user.activities.create!(target_id: @article.id, target_type: "Article", activity_type: 4,
																		title: @article.title, content: @article.content, publish_date: DateUtils.to_yyyymmdd(Date.today), 
																		theme:@article.theme, recent_flag: true)
		  redirect_to article_path(@article), notice: 'Comment was successfully created.'
		end
		# 答案评论
		if params[:answer_id] != nil
			@answer = Answer.find(params[:answer_id])
			@question = @answer.question
			# 创建答案评论
			@comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:answer_id]
			@comment.commentable_type = "Answer"
			@comment.save!
			# 创建消息并发送
			if current_user.user_setting.commented_flag == true
				msg_content = "New comment for your answer of question: " + @question.title + "."
				@answer.user.messages.create!(content: msg_content, msg_type: 1)
			end
			# 创建用户行为（评论答案）
			current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 3,
																		title: @question.title, content: @answer.content, publish_date: DateUtils.to_yyyymmdd(Date.today), 
																		theme:@question.theme, recent_flag: true)
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
      params.require(:comment).permit(:content, :user_id, :commentable_id, :commentable_type)
    end		
end
