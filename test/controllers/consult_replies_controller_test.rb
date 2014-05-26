require 'test_helper'

class ConsultRepliesControllerTest < ActionController::TestCase
  setup do
    @consult_reply = consult_replies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consult_replies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consult_reply" do
    assert_difference('ConsultReply.count') do
      post :create, consult_reply: { consult_subject_id: @consult_reply.consult_subject_id, content: @consult_reply.content, user_id: @consult_reply.user_id }
    end

    assert_redirected_to consult_reply_path(assigns(:consult_reply))
  end

  test "should show consult_reply" do
    get :show, id: @consult_reply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consult_reply
    assert_response :success
  end

  test "should update consult_reply" do
    patch :update, id: @consult_reply, consult_reply: { consult_subject_id: @consult_reply.consult_subject_id, content: @consult_reply.content, user_id: @consult_reply.user_id }
    assert_redirected_to consult_reply_path(assigns(:consult_reply))
  end

  test "should destroy consult_reply" do
    assert_difference('ConsultReply.count', -1) do
      delete :destroy, id: @consult_reply
    end

    assert_redirected_to consult_replies_path
  end
end
