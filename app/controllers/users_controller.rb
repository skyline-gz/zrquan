require "returncode_define.rb"

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow]
  before_action :authenticate_user!

  # 个人设置，更改密码
  def update_password
    if params[:password] != params[:password_confirmation]
      render :json => {:code => ReturnCode::FA_PASSWORD_INCONSISTENT}
    end
    @user = User.find(current_user.id)
    if @user.update_with_password(user_update_password_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_PASSWORD_ERROR}
    end
  end

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
    @is_self = false
    if current_user
      @is_self = (@user.id == current_user.id)
    end
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

    def user_update_password_params
      params.permit(:current_password, :password, :password_confirmation)
    end
end
