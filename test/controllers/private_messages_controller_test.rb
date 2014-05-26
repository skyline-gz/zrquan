require 'test_helper'

class PrivateMessagesControllerTest < ActionController::TestCase
  setup do
    @private_message = private_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:private_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create private_message" do
    assert_difference('PrivateMessage.count') do
      post :create, private_message: { content: @private_message.content, read_flag: @private_message.read_flag, send_class: @private_message.send_class, user1_id: @private_message.user1_id, user2_id: @private_message.user2_id }
    end

    assert_redirected_to private_message_path(assigns(:private_message))
  end

  test "should show private_message" do
    get :show, id: @private_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @private_message
    assert_response :success
  end

  test "should update private_message" do
    patch :update, id: @private_message, private_message: { content: @private_message.content, read_flag: @private_message.read_flag, send_class: @private_message.send_class, user1_id: @private_message.user1_id, user2_id: @private_message.user2_id }
    assert_redirected_to private_message_path(assigns(:private_message))
  end

  test "should destroy private_message" do
    assert_difference('PrivateMessage.count', -1) do
      delete :destroy, id: @private_message
    end

    assert_redirected_to private_messages_path
  end
end
