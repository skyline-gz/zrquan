require "returncode_define.rb"

class UsersController < ApplicationController
  before_action :set_user_by_token_id, only: [:follow, :un_follow, :profile]
  before_action :set_user_by_url_id, only: [:show,:questions, :answers, :bookmarks]
  before_action :authenticate_user!, except: [:profile]

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
    # 详细页默认显示答案
    params[:action] = 'answers'
  end

  def questions
    render 'show'
  end

  def answers
    render 'show'
  end

  def bookmarks
    render 'show'
  end

  # 个人简介卡片内容
  def profile
    render 'partials/profile_card_content', layout: false
  end

  # 关注用户
  def follow
    id = @user.id
    if current_user.id == id
      render :json => { :code => ReturnCode::FA_INVALID_TARGET_ERROR } and return
    end
    relationship = Relationship.find_by(:following_user_id => id, :follower_id => current_user.id)
    if relationship
      render :json => { :code => ReturnCode::FA_RELATIONSHIP_ALREADY_EXIT}
    else
      Relationship.create(:following_user_id => id, :follower_id => current_user.id)
      render :json => { :code => ReturnCode::S_OK}
    end
  end

  # 取消关注用户
  def un_follow
    id = @user.id
    if current_user.id == id
      render :json => { :code => ReturnCode::FA_INVALID_TARGET_ERROR } and return
    end
    relationship = Relationship.find_by(:following_user_id => id, :follower_id => current_user.id)
    if relationship
      relationship.destroy
      render :json => { :code => ReturnCode::S_OK}
    else
      render :json => { :code => ReturnCode::FA_RELATIONSHIP_NOT_EXIT}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_by_token_id
      @user = User.find_by_token_id(params[:id])
    end

    def set_user_by_url_id
      @user = User.find_by_url_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:last_name, :first_name, :signature, :avatar)
    end
end
