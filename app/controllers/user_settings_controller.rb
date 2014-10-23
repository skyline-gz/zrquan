class UserSettingsController < ApplicationController
  before_action :set_user_setting, only: [:show, :edit, :update, :destroy]

  # 显示
  def show
  end

  # 新建用户设置对象
  def new
    @user_setting = UserSetting.new
  end

  # 编辑
  def edit
    authorize! :edit, @user_setting
  end

  # 更新
  def update
    respond_to do |format|
      if @user_setting.update(user_setting_params)
        format.html { redirect_to @user_setting, notice: 'User setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_setting }
      else
        format.html { render :edit }
        format.json { render json: @user_setting.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_setting
      @user_setting = UserSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_setting_params
      params.require(:user_setting).permit(:followed_flag, :aggred_flag, :commented_flag, :answer_flag, :pm_flag)
    end
end
