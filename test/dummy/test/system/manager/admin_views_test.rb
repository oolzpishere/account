require "application_system_test_case"

class Manager::AdminViewsTest < ApplicationSystemTestCase
  setup do
    @manager_admin_view = manager_admin_views(:one)
  end

  test "visiting the index" do
    visit manager_admin_views_url
    assert_selector "h1", text: "Admin views"
  end

  test "should create admin view" do
    visit manager_admin_views_url
    click_on "New admin view"

    click_on "Create Admin view"

    assert_text "Admin view was successfully created"
    click_on "Back"
  end

  test "should update Admin view" do
    visit manager_admin_view_url(@manager_admin_view)
    click_on "Edit this admin view", match: :first

    click_on "Update Admin view"

    assert_text "Admin view was successfully updated"
    click_on "Back"
  end

  test "should destroy Admin view" do
    visit manager_admin_view_url(@manager_admin_view)
    click_on "Destroy this admin view", match: :first

    assert_text "Admin view was successfully destroyed"
  end
end
