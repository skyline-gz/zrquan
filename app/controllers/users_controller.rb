require "returncode_define.rb"

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :questions, :answers, :bookmarks]
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

    @industry = nil
    if @user.industry_id
      @industry = Industry.find(@user.industry_id)
    end

    @company = nil
    if @user.latest_company_id
      @company = Company.find(@user.latest_company_id)
    end

    @region = @location = nil
    if @user.location_id
      @location = Location.find(@user.location_id)
      @region = Region.find(@location.region_id)
    end

    @school = nil
    if @user.latest_school_id
      @school = School.find(@user.latest_school_id)
    end

    @questions = Question.where(:user_id => @user.id)
    @answers = Answer.where(:user_id => @user.id)
    @bookmarks = Bookmark.where(:user_id => @user.id, :bookmarkable_type => 'Question')
    @bookmark_questions = []
    @bookmarks.each do |bookmark|
      @bookmark_questions.push Question.find bookmark.bookmarkable_id
    end
  end

  def questions
    show
    render 'show'
  end

  def answers
    show
    render 'show'
  end

  def bookmarks
    show
    render 'show'
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
