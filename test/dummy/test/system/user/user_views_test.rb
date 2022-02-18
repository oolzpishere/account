require "application_system_test_case"

class User::UserViewsTest < ApplicationSystemTestCase
  setup do
    @user_user_view = user_user_views(:one)
  end

  test "visiting the index" do
    visit user_user_views_url
    assert_selector "h1", text: "User views"
  end

  test "should create user view" do
    visit user_user_views_url
    click_on "New user view"

    click_on "Create User view"

    assert_text "User view was successfully created"
    click_on "Back"
  end

  test "should update User view" do
    visit user_user_view_url(@user_user_view)
    click_on "Edit this user view", match: :first

    click_on "Update User view"

    assert_text "User view was successfully updated"
    click_on "Back"
  end

  test "should destroy User view" do
    visit user_user_view_url(@user_user_view)
    click_on "Destroy this user view", match: :first

    assert_text "User view was successfully destroyed"
  end
end
