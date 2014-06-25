class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
		if params[:article_id] != nil
			@article = Article.find(params[:article_id])
			# will not rollback if message cannnot be created
		  @comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:article_id]
			@comment.commentable_type = "Article"
			@comment.save!
			if current_user.user_setting.commented_flag == true
				msg_content = "New comment for your article: " + @article.title + "."
				@article.user.messages.create!(content: msg_content, msg_type: 1)
			end
		  redirect_to article_path(@article), notice: 'Comment was successfully created.'
		end
		if params[:answer_id] != nil
			@answer = Answer.find(params[:answer_id])
			@question = @answer.question
			# will not rollback if message cannnot be created
			@comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:answer_id]
			@comment.commentable_type = "Answer"
			@comment.save!
			if current_user.user_setting.commented_flag == true
				msg_content = "New comment for your answer of question: " + @question.title + "."
				@answer.user.messages.create!(content: msg_content, msg_type: 1)
			end
		  redirect_to question_path(@question), notice: 'Comment was successfully created.'
		end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment.update_attributes!(comment_params)
    redirect_to @comment, notice: 'Comment was successfully updated.'
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  #def destroy
  #  @comment.destroy
  #  respond_to do |format|
  #    format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

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
