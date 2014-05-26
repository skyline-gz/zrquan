require 'test_helper'

class ConsultSubjectsControllerTest < ActionController::TestCase
  setup do
    @consult_subject = consult_subjects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consult_subjects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consult_subject" do
    assert_difference('ConsultSubject.count') do
      post :create, consult_subject: { apprentice_id: @consult_subject.apprentice_id, content: @consult_subject.content, mentor_id: @consult_subject.mentor_id, mentor_stat_flag: @consult_subject.mentor_stat_flag, theme_id: @consult_subject.theme_id, title: @consult_subject.title, user_stat_flag: @consult_subject.user_stat_flag }
    end

    assert_redirected_to consult_subject_path(assigns(:consult_subject))
  end

  test "should show consult_subject" do
    get :show, id: @consult_subject
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consult_subject
    assert_response :success
  end

  test "should update consult_subject" do
    patch :update, id: @consult_subject, consult_subject: { apprentice_id: @consult_subject.apprentice_id, content: @consult_subject.content, mentor_id: @consult_subject.mentor_id, mentor_stat_flag: @consult_subject.mentor_stat_flag, theme_id: @consult_subject.theme_id, title: @consult_subject.title, user_stat_flag: @consult_subject.user_stat_flag }
    assert_redirected_to consult_subject_path(assigns(:consult_subject))
  end

  test "should destroy consult_subject" do
    assert_difference('ConsultSubject.count', -1) do
      delete :destroy, id: @consult_subject
    end

    assert_redirected_to consult_subjects_path
  end
end
