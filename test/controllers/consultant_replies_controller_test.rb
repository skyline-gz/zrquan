require 'test_helper'

class ConsultantRepliesControllerTest < ActionController::TestCase
  setup do
    @consultant_reply = consultant_replies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consultant_replies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consultant_reply" do
    assert_difference('ConsultantReply.count') do
      post :create, consultant_reply: { consultant_subject_id: @consultant_reply.consultant_subject_id, content: @consultant_reply.content, reply_seq: @consultant_reply.reply_seq, user_id: @consultant_reply.user_id }
    end

    assert_redirected_to consultant_reply_path(assigns(:consultant_reply))
  end

  test "should show consultant_reply" do
    get :show, id: @consultant_reply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consultant_reply
    assert_response :success
  end

  test "should update consultant_reply" do
    patch :update, id: @consultant_reply, consultant_reply: { consultant_subject_id: @consultant_reply.consultant_subject_id, content: @consultant_reply.content, reply_seq: @consultant_reply.reply_seq, user_id: @consultant_reply.user_id }
    assert_redirected_to consultant_reply_path(assigns(:consultant_reply))
  end

  test "should destroy consultant_reply" do
    assert_difference('ConsultantReply.count', -1) do
      delete :destroy, id: @consultant_reply
    end

    assert_redirected_to consultant_replies_path
  end
end
