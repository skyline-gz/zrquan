require "returncode_define.rb"

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow]
  before_action :authenticate_user!

  # 全用户列表
  def index
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
