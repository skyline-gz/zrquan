class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy, :agree]

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
		# create answer
    @answer = current_user.answers.new(answer_params)
		@answer.question_id = params[:question_id]
		@answer.save!
		# update question answer num
		@question = Question.find(@answer.question_id)
		@question.update_attributes!(answer_num: @question.answer_num + 1)
		# create activity
		current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 2,
																		title: @question.title, content: @answer.content, publish_date: today_to_i, 
																		theme:@question.theme, recent_flag: true)
		# will not rollback if message cannot be created
		if current_user.user_setting.answer_flag == true
			msg_content = "New answer for your question: " + @question.title + "."
			@question.user.messages.create!(content: msg_content, msg_type: 1)
			# TODO publish to faye
		end
		
	  redirect_to question_path(@question), notice: 'Answer was successfully created.'
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
		@question = Question.find(@answer.question_id)
		# update answers
		@answer.update_attributes!(answer_params)
		# create message
		if current_user.user_setting.answer_flag == true
			msg_content = "Answer for your question: " + @question.title + " has been updated."
			@question.user.messages.create!(content: msg_content, msg_type: 1)
			# TODO publish to faye
		end
	  redirect_to question_path(@question), notice: 'Answer was successfully updated.'
  end

	def agree
		@question = Question.find(@answer.question_id)
		latest_score = @answer.agree_score
		logger.debug(latest_score)
		# agree from mentor plus 2 and agree from normal user plus 1
		if current_user.mentor_flag
			latest_score = latest_score + 2
			@answer.update_attributes!(:agree_score => latest_score)
		else
			latest_score = latest_score + 1
			@answer.update_attributes!(:agree_score => latest_score)
		end
		if @answer.user.user_setting.aggred_flag
			logger.debug("message")
			msg_content = current_user.email + " agreed your answer for " + @question.title + "."
			@answer.user.messages.create!(content: msg_content, msg_type: 1)
		end
		# create agreement
		current_user.agreements.create!(agreeable_id: @answer.id, agreeable_type: "Answer")
		# create activity
		current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 5,
																		title: @question.title, content: @answer.content, publish_date: today_to_i, 
																		theme:@question.theme, recent_flag: true)
	  redirect_to question_path(@question), notice: 'Answer was successfully updated.'
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

		def today_to_i
			Date.today.to_s.gsub("-", "").to_i
		end
end
