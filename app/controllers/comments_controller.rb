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
		  @comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:article_id]
			@comment.commentable_type = "Article"

			@article = Article.find(params[:article_id])
			begin
				ActiveRecord::Base.transaction do
					@comment.save!
					if current_user.user_setting.commented_flag == true
						msg_content = "New comment for your article: " + @article.title + "."
						create_message(msg_content, 1, @article.user_id)
					end
				end
				respond_to do |format|
			    format.html { redirect_to article_path(@article), notice: 'Comment was successfully created.' }
			    #format.json { render :show, status: :created, location: @comment }
				end
			rescue => e
				respond_to do |format|
				  #format.html { render :new }
				  #format.json { render json: @comment.errors, status: :unprocessable_entity }
				end
			end
		end
		if params[:answer_id] != nil
			@comment = current_user.comments.new(comment_params)
			@comment.commentable_id = params[:answer_id]
			@comment.commentable_type = "Answer"

			@answer = Answer.find(params[:answer_id])
			@question = @answer.question

			begin
				ActiveRecord::Base.transaction do
					@comment.save!
					if current_user.user_setting.commented_flag == true
						msg_content = "New comment for your answer of question: " + @question.title + "."
						create_message(msg_content, 1, @answer.user_id)
					end
				end
				respond_to do |format|
			    format.html { redirect_to question_path(@question), notice: 'Comment was successfully created.' }
			    #format.json { render :show, status: :created, location: @comment }
				end
			rescue => e
				respond_to do |format|
			    format.html { render :new }
			    format.json { render json: @comment.errors, status: :unprocessable_entity }
				end
			end
		end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
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
		
		def create_message(content, msg_type, user_id)
			@message = Message.new
			@message.content = content
			@message.msg_type = msg_type 	#fake type
			@message.user_id = user_id
			@message.save!
		end
end
