class ConsultantRepliesController < ApplicationController
  before_action :set_consultant_reply, only: [:show, :edit, :update, :destroy]

  # GET /consultant_replies
  # GET /consultant_replies.json
  def index
    @consultant_replies = ConsultantReply.all
  end

  # GET /consultant_replies/1
  # GET /consultant_replies/1.json
  def show
  end

  # GET /consultant_replies/new
  def new
    @consultant_reply = ConsultantReply.new
  end

  # GET /consultant_replies/1/edit
  def edit
  end

  # POST /consultant_replies
  # POST /consultant_replies.json
  def create
    @consultant_reply = ConsultantReply.new(consultant_reply_params)

    respond_to do |format|
      if @consultant_reply.save
        format.html { redirect_to @consultant_reply, notice: 'Consultant reply was successfully created.' }
        format.json { render :show, status: :created, location: @consultant_reply }
      else
        format.html { render :new }
        format.json { render json: @consultant_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultant_replies/1
  # PATCH/PUT /consultant_replies/1.json
  def update
    respond_to do |format|
      if @consultant_reply.update(consultant_reply_params)
        format.html { redirect_to @consultant_reply, notice: 'Consultant reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @consultant_reply }
      else
        format.html { render :edit }
        format.json { render json: @consultant_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consultant_replies/1
  # DELETE /consultant_replies/1.json
  def destroy
    @consultant_reply.destroy
    respond_to do |format|
      format.html { redirect_to consultant_replies_url, notice: 'Consultant reply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultant_reply
      @consultant_reply = ConsultantReply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consultant_reply_params
      params.require(:consultant_reply).permit(:consultant_subject_id, :reply_seq, :content, :user_id)
    end
end
