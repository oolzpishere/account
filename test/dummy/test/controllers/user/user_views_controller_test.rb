require "test_helper"

class User::UserViewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_user_view = user_user_views(:one)
  end

  test "should get index" do
    get user_user_views_url
    assert_response :success
  end

  test "should get new" do
    get new_user_user_view_url
    assert_response :success
  end

  test "should create user_user_view" do
    assert_difference("User::UserView.count") do
      post user_user_views_url, params: { user_user_view: {  } }
    end

    assert_redirected_to user_user_view_url(User::UserView.last)
  end

  test "should show user_user_view" do
    get user_user_view_url(@user_user_view)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_user_view_url(@user_user_view)
    assert_response :success
  end

  test "should update user_user_view" do
    patch user_user_view_url(@user_user_view), params: { user_user_view: {  } }
    assert_redirected_to user_user_view_url(@user_user_view)
  end

  test "should destroy user_user_view" do
    assert_difference("User::UserView.count", -1) do
      delete user_user_view_url(@user_user_view)
    end

    assert_redirected_to user_user_views_url
  end
end
