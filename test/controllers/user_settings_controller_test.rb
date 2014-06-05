require 'test_helper'

class UserSettingsControllerTest < ActionController::TestCase
  setup do
    @user_setting = user_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_setting" do
    assert_difference('UserSetting.count') do
      post :create, user_setting: { aggred_flag: @user_setting.aggred_flag, answer_flag: @user_setting.answer_flag, commented_flag: @user_setting.commented_flag, followed_flag: @user_setting.followed_flag, pm_flag: @user_setting.pm_flag }
    end

    assert_redirected_to user_setting_path(assigns(:user_setting))
  end

  test "should show user_setting" do
    get :show, id: @user_setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_setting
    assert_response :success
  end

  test "should update user_setting" do
    patch :update, id: @user_setting, user_setting: { aggred_flag: @user_setting.aggred_flag, answer_flag: @user_setting.answer_flag, commented_flag: @user_setting.commented_flag, followed_flag: @user_setting.followed_flag, pm_flag: @user_setting.pm_flag }
    assert_redirected_to user_setting_path(assigns(:user_setting))
  end

  test "should destroy user_setting" do
    assert_difference('UserSetting.count', -1) do
      delete :destroy, id: @user_setting
    end

    assert_redirected_to user_settings_path
  end
end
