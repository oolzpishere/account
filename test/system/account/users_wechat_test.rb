require "application_system_test_case"

module Account
  class UsersWechatTest < ApplicationSystemTestCase
    setup do

    end

    # Reset sessions and driver between tests
    teardown do
      Capybara.reset_sessions!
      # Capybara.use_default_driver
    end

    test "login with new wechat" do
      visit "/users/sign_in"
      click_button '微信登录'
      assert_content '用户登录成功'
    end
    
  end
end
