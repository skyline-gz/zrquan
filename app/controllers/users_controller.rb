class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
		logger.debug("start index")
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
  end

  # GET /users/new
  def new
		logger.debug("start new")
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    
  end

  # POST /users
  # POST /users.json
  def create
    logger.debug(user_params)
    @user = User.new(user_params)
		logger.debug("start create")

    respond_to do |format|
      if @user.save
				# create default user_setting for this user 
				@user_setting =	UserSetting.new
				logger.debug("user saved")
				@user_setting.followed_flag = true
				@user_setting.aggred_flag = true
				@user_setting.commented_flag = true
				@user_setting.answer_flag = true
				@user_setting.pm_flag = true
				@user_setting.user_id = @user.id
				if @user_setting.save
					logger.debug("user_setting saved")
					#	logger.debug("user setting save ok.")
					#else
					#	logger.debug("user setting save failed.")
					#end
			    format.html { redirect_to @user, notice: 'User was successfully created.' }
			    format.json { render :show, status: :created, location: @user }
				end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

	def follow
		begin
			ActiveRecord::Base.transaction do
				@relationship = current_user.relationships.new
				@relationship.following_user_id = params[:id]
				@relationship.save!
				if current_user.user_setting.followed_flag == true
					msg_content = current_user.last_name + current_user.first_name + " is following you."
					create_message(msg_content, 1, @relationship.following_user_id)
				end
			end
			respond_to do |format|
				format.html { redirect_to users_path, notice: 'Following user succeed.' }
        format.json { render :show, status: :ok, location: @user }
			end
		rescue => e
			respond_to do |format|
				format.html { render :follow }
        format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def unfollow
		@relationship = current_user.relationships.find_by_following_user_id(params[:id])
		@relationship.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'Unfollow user succeed.' }
      format.json { head :no_content }
    end
	end

  # DELETE /users/1
  # DELETE /users/1.json
  #def destroy
  #  @user.destroy
  #  respond_to do |format|
  #    format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
		
		def create_message(content, msg_type, user_id)
			@message = Message.new
			@message.content = content
			@message.msg_type = msg_type 	#fake type
			@message.user_id = user_id
			@message.save!
		end
end
