class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow]
  before_action :authenticate_user!

  # 全用户列表
  def index
    logger.debug("start index")
    @users = User.all
  end

	# 认证职场人列表
  def verified_users
    @verified_users = User.all.where(verified_flag: true)
  end

  # 显示
  def show
  end

  # 新建用户对象
  def new
    logger.debug("start new")
    @user = User.new
  end

  # 编辑
  def edit
    authorize! :edit, @user
  end

  # POST /users
  # POST /users.json
  #def create
  #  @user = User.new(user_params)
  #  respond_to do |format|
  #    if @user.save
	#			# create default user_setting for this user 
	#			@user_setting =	UserSetting.new
	#			@user_setting.followed_flag = true
	#			@user_setting.aggred_flag = true
	#			@user_setting.commented_flag = true
	#			@user_setting.answer_flag = true
	#			@user_setting.pm_flag = true
	#			@user_setting.user_id = @user.id
	#			if @user_setting.save
	#		    format.html { redirect_to @user, notice: 'User was successfully created.' }
	#		    format.json { render :show, status: :created, location: @user }
	#			end
  #    else
  #      format.html { render :new }
  #      format.json { render json: @user.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # 更新
  def update
    @user.update!(user_params)
    redirect_to @user, notice: 'User was successfully updated.'
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
      params.require(:user).permit(:last_name, :first_name, :signature, :avatar)
    end
end
