require "application_system_test_case"

class UserTest < ApplicationSystemTestCase
  def setup
    @user = create_user
    @pw = "12345678"
  end

  test "email login" do
    visit "/user/user_views"

    fill_in "user[login]", with: @user.email
    fill_in "user[password]", with: @pw

    click_button '登录'

    assert_content '登录成功'
  end

  test "email login with wrong password" do
    visit "/user/user_views"

    fill_in "user[login]", with: @user.email
    fill_in "user[password]", with: "wrong_password"

    click_button '登录'

    assert_content '或密码错误'
  end

  test "phone login" do
    visit "/user/user_views"

    fill_in "user[login]", with: @user.phone
    fill_in "user[password]", with: @pw

    click_button '登录'

    assert_content '登录成功'
  end

end
