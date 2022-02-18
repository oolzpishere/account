require "test_helper"

class Manager::AdminViewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_admin_view = manager_admin_views(:one)
  end

  test "should get index" do
    get manager_admin_views_url
    assert_response :success
  end

  test "should get new" do
    get new_manager_admin_view_url
    assert_response :success
  end

  test "should create manager_admin_view" do
    assert_difference("Manager::AdminView.count") do
      post manager_admin_views_url, params: { manager_admin_view: {  } }
    end

    assert_redirected_to manager_admin_view_url(Manager::AdminView.last)
  end

  test "should show manager_admin_view" do
    get manager_admin_view_url(@manager_admin_view)
    assert_response :success
  end

  test "should get edit" do
    get edit_manager_admin_view_url(@manager_admin_view)
    assert_response :success
  end

  test "should update manager_admin_view" do
    patch manager_admin_view_url(@manager_admin_view), params: { manager_admin_view: {  } }
    assert_redirected_to manager_admin_view_url(@manager_admin_view)
  end

  test "should destroy manager_admin_view" do
    assert_difference("Manager::AdminView.count", -1) do
      delete manager_admin_view_url(@manager_admin_view)
    end

    assert_redirected_to manager_admin_views_url
  end
end
