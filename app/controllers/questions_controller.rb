class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /questions
  # GET /questions.json
  def index
    logger.debug(current_user)
    logger.debug("123")
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
		#@user = User.find(params[:id])
		#@questions = @user.questions
  end

  # GET /questions/new
  def new
    @question = Question.new
		@question.invitations.build
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
		begin
			ActiveRecord::Base.transaction do
		  	@question = current_user.questions.new(question_params)
				@question.save!
				
				logger.debug(invitations_params)
				if invitations_params != {}
					logger.debug("creating invitations")
					invitations_params[:invitations_attributes]["0"][:mentor_id].each do |m_id|
						@invitation = Invitation.new
						@invitation.question_id = @question.id
						@invitation.mentor_id = m_id
						@invitation.save!
						# send message to invited mentor
						msg_content = "You are invited to answer " + @question.title + "."
						create_message(msg_content, 1, m_id)
					end
				end
			end
			respond_to do |format|
				format.html { redirect_to @question, notice: 'Question was successfully created.' }
		    format.json { render :show, status: :created, location: @question }
			end
		rescue => e
		  respond_to do |format|
	      format.html { render :new }
	      format.json { render json: @question.errors, status: :unprocessable_entity }
		  end
		end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
		begin
			ActiveRecord::Base.transaction do
				@question.update_attributes!(question_params)
				logger.debug("question updated")
				if !Invitation.destroy_all(question_id:@question.id)
					raise ActiveRecord::Rollback
				end
				logger.debug("invitation destroyed")
				invitations_params[:invitations_attributes]["0"][:mentor_id].each do |m_id|
					@invitation = Invitation.new
					@invitation.question_id = @question.id
					@invitation.mentor_id = m_id
					@invitation.save!
					# send message to invited mentor
					msg_content = "You are invited to answer " + @question.title + "."
					create_message(msg_content, 1, m_id)
				end
				logger.debug("invitation saved")
			end
			respond_to do |format|
				format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
			end
		rescue => e
		  respond_to do |format|
	      format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
		  end
		end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  #def destroy
  #  @question.destroy
  #  respond_to do |format|
  #    format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :content, :theme_id, :industry_id, :category_id, :answer_num, :mark_flag)
    end

		def invitations_params
      params.require(:question).permit(invitations_attributes:[:mentor_id=>[]])
    end

		def create_message(content, msg_type, user_id)
			@message = Message.new
			@message.content = content
			@message.msg_type = msg_type 	#fake type
			@message.user_id = user_id
			@message.save!
		end
end
