class PrivateMessagesController < ApplicationController
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]

  # GET /private_messages
  # GET /private_messages.json
  def index
		@target_user = User.find(params[:id])
		#@target_user.first_name = params[:first_name]
		#@target_user.last_name = params[:last_name]
		if current_user.id > @target_user.id
	    @private_messages = PrivateMessage.where(user1_id: @target_user.id, user2_id: current_user.id)
		else
	    @private_messages = PrivateMessage.where(user1_id: current_user.id, user2_id: @target_user.id)
		end
  end

  # GET /private_messages/1
  # GET /private_messages/1.json
  def show
  end

  # GET /private_messages/new
  def new
    @private_message = PrivateMessage.new
  end

  # GET /private_messages/1/edit
  #def edit
  #end

  # POST /private_messages
  # POST /private_messages.json
  def create
    @private_message = PrivateMessage.new
		@private_message.content = private_message_params[:content]
		if current_user.id < private_message_params[:target_user_id].to_i
			@private_message.user1_id = current_user.id
			@private_message.user2_id = private_message_params[:target_user_id]
			@private_message.send_class = 1
		else
			@private_message.user1_id = private_message_params[:target_user_id]
			@private_message.user2_id = current_user.id
			@private_message.send_class = 2
		end
    @private_message.save!
    redirect_to :back, notice: 'Private message was successfully created.'
  end

  # PATCH/PUT /private_messages/1
  # PATCH/PUT /private_messages/1.json
  #def update
  #  respond_to do |format|
  #    if @private_message.update(private_message_params)
  #      format.html { redirect_to @private_message, notice: 'Private message was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @private_message }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @private_message.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /private_messages/1
  # DELETE /private_messages/1.json
  #def destroy
  #  @private_message.destroy
  #  respond_to do |format|
  #    format.html { redirect_to private_messages_url, notice: 'Private message was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private_message
      @private_message = PrivateMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def private_message_params
      params.permit(:content, :target_user_id)
    end
end
