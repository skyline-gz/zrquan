require 'test_helper'

class ConsultantSubjectsControllerTest < ActionController::TestCase
  setup do
    @consultant_subject = consultant_subjects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consultant_subjects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consultant_subject" do
    assert_difference('ConsultantSubject.count') do
      post :create, consultant_subject: { apprentice_id: @consultant_subject.apprentice_id, content: @consultant_subject.content, mentor_id: @consultant_subject.mentor_id, mentor_stat_flag: @consultant_subject.mentor_stat_flag, theme_id: @consultant_subject.theme_id, title: @consultant_subject.title, user_stat_flag: @consultant_subject.user_stat_flag }
    end

    assert_redirected_to consultant_subject_path(assigns(:consultant_subject))
  end

  test "should show consultant_subject" do
    get :show, id: @consultant_subject
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consultant_subject
    assert_response :success
  end

  test "should update consultant_subject" do
    patch :update, id: @consultant_subject, consultant_subject: { apprentice_id: @consultant_subject.apprentice_id, content: @consultant_subject.content, mentor_id: @consultant_subject.mentor_id, mentor_stat_flag: @consultant_subject.mentor_stat_flag, theme_id: @consultant_subject.theme_id, title: @consultant_subject.title, user_stat_flag: @consultant_subject.user_stat_flag }
    assert_redirected_to consultant_subject_path(assigns(:consultant_subject))
  end

  test "should destroy consultant_subject" do
    assert_difference('ConsultantSubject.count', -1) do
      delete :destroy, id: @consultant_subject
    end

    assert_redirected_to consultant_subjects_path
  end
end
