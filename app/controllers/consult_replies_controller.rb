class ConsultRepliesController < ApplicationController
  before_action :set_consult_reply, only: [:show, :edit, :update, :destroy]

  # GET /consult_replies
  # GET /consult_replies.json
  def index
    @consult_replies = ConsultReply.all
  end

  # GET /consult_replies/1
  # GET /consult_replies/1.json
  def show
  end

  # GET /consult_replies/new
  def new
    @consult_reply = ConsultReply.new
  end

  # GET /consult_replies/1/edit
  def edit
  end

  # POST /consult_replies
  # POST /consult_replies.json
  def create
		# save consult_reply
		@consult_reply = current_user.consult_replies.build(consult_reply_params)
		@consult_reply.consult_subject_id = params[:consult_subject_id]
		@consult_reply.save!
		# save message
		@consult_subject = ConsultSubject.find(params[:consult_subject_id])
		if current_user.id == @consult_subject.mentor_id
			user_id = @consult_subject.apprentice_id
		else
			user_id = @consult_subject.mentor_id				
		end
		msg_content = "New consult reply for " + @consult_subject.title + "."
		Message.create!(content: msg_content, msg_type: 1, user_id: user_id)
		respond_to do |format|
	    format.html { redirect_to consult_subject_path(@consult_subject), notice: 'Consult reply was successfully created.' }
	    format.json { render :show, status: :created, location: @consult_reply }
		end
  end

  # PATCH/PUT /consult_replies/1
  # PATCH/PUT /consult_replies/1.json
  def update
		@consult_reply.update_attributes!(consult_reply_params)
    respond_to do |format|
      format.html { redirect_to @consult_reply, notice: 'Consult reply was successfully updated.' }
      format.json { render :show, status: :ok, location: @consult_reply }
    end
  end

  # DELETE /consult_replies/1
  # DELETE /consult_replies/1.json
  #def destroy
  #  @consult_reply.destroy
  #  respond_to do |format|
  #    format.html { redirect_to consult_replies_url, notice: 'Consult reply was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consult_reply
      @consult_reply = ConsultReply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consult_reply_params
      params.require(:consult_reply).permit(:consult_subject_id, :content, :user_id)
    end
end
