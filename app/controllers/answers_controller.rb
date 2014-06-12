class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = current_user.answers.new(answer_params)
		@answer.question_id = params[:question_id]

		@question = Question.find(params[:question_id])
    begin
			ActiveRecord::Base.transaction do
				@answer.save!
				if current_user.user_setting.answer_flag == true
					msg_content = "New answer for your question: " + @question.title + "."
					create_message(msg_content, 1)
					# TODO publish to faye
				end
			end
			respond_to do |format|
		    format.html { redirect_to question_path(@question), notice: 'Answer was successfully created.' }
		    format.json { render :show, status: :created, location: @answer }
			end
		rescue => e    
			respond_to do |format|
		    format.html { render :new }
		    #format.json { render json: @answer.errors, status: :unprocessable_entity }		
		  end
		end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
		@question = Question.find(@answer.question_id)
		begin
			# cause we should both update answer and create message, use transaction
			ActiveRecord::Base.transaction do
				# update answers
				@answer.update_attributes!(answer_params)
				# create message
				if current_user.user_setting.answer_flag == true
					msg_content = "Answer for your question: " + @question.title + " has been updated."
					create_message(msg_content, 1)
					# TODO publish to faye
				end
			end
		  respond_to do |format|
		    format.html { redirect_to question_path(@question), notice: 'Answer was successfully updated.' }
		    format.json { render :show, status: :ok, location: @answer }
			end
		rescue => e
		  respond_to do |format|
		    format.html { render :edit }
		    format.json { render json: @answer.errors, status: :unprocessable_entity }
		  end
		end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  #def destroy
  #  @answer.destroy
  #  respond_to do |format|
  #    format.html { redirect_to answers_url, notice: 'Answer was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content, :agree_score, :user_id, :question_id)
    end

		def create_message(content, msg_type)
			@message = Message.new
			@message.content = content
			@message.msg_type = msg_type 	#fake type
			@message.user_id = @question.user_id
			@message.save!
		end
end
