require "application_system_test_case"

class PhoneVerificationsTest < ApplicationSystemTestCase
  def setup
    @user = new_user
    @template_code = "276826"
    @phone = @user.phone
    @fake_verification_code = '123456'
    # Account::User.any_instance.stubs(:otp_code).returns( @fake_verification_code )
  end

  # Reset sessions and driver between tests
  teardown do
    Capybara.reset_sessions!
    # Capybara.use_default_driver
  end

  test "login with new phone" do
    visit "/phone_verification/login"
    fill_in 'phone', with: @user.phone

    params = [@fake_verification_code, Account::SendOtpService::DRIFT_MINUTES.to_s]

    # Qcloud::Sms.expects(:single_sender).with(@user.phone, @template_code, params).returns(true)
    Qcloud::Sms.stubs(:single_sender).returns(true)
    click_link '发送验证码'

    # puts page.evaluate_script("document.querySelector('#verify_phone_label').textContent;")
    # test_otp_code =  page.evaluate_script("document.querySelector('#test-otp-code').textContent;")
    test_otp_code_path = "#{Rails.root}/tmp/test_otp_code"
    if File.exist?(test_otp_code_path)
      test_otp_code =  File.read( test_otp_code_path )
      File.delete( test_otp_code_path )
    end

    assert find('#send_verification_code', class: 'disabled')

    fill_in 'verification_code', with: test_otp_code

    click_button '登录'
    # assert_content '用户登录成功'
  end

  test "login with right phone, same phone of create_user, right otp" do
    Account::User.any_instance.stubs(:authenticate_otp).returns( true )
    Account::User.any_instance.stubs(:otp_code).returns( @fake_verification_code )
    params = [@fake_verification_code, Account::SendOtpService::DRIFT_MINUTES.to_s]

    # mock send sms.
    # Qcloud::Sms.single_sender(phone, @template_code, params)
    Qcloud::Sms.expects(:single_sender).with(@user.phone, @template_code, params).returns(true)

    # mock after_sign_in_path_for
    # Account::PhoneVerificationController.any_instance.stubs(:after_sign_in_path_for).returns(user_views_path)
    visit "/phone_verification/login"

    fill_in 'phone', with: @user.phone

    click_link '发送验证码'
    # countDown test
    assert_content '再次发送验证码'
    assert find('#send_verification_code', class: 'disabled')

    using_wait_time 5 do
      fill_in 'verification_code', with: @fake_verification_code
    end
    click_button '登录'

    assert_content '用户登录成功'
    # assert_content @user.phone
  end

  test "login with wrong phone number" do
    short_phone = "123"

    visit "/phone_verification/login"

    fill_in 'phone', with: short_phone

    click_link '发送验证码'

    assert_content '号码格式不正确'
  end

  test "login with diff phone of create_user" do
    diff_phone = "12345678900"

    visit "/phone_verification/login"

    fill_in 'phone', with: diff_phone

    click_link '发送验证码'
    # countDown test
    # assert_no_text '再次发送验证码'
    # assert has_no_css?('#send_verification_code', class: 'disabled')
    #
    # assert_content '此号码未注册用户，请重新填写'
  end

  test "login with same phone of create_user, but wrong otp" do
    wrong_verification_code = "654321"
    Qcloud::Sms.stubs(:single_sender).returns(true)

    visit "/phone_verification/login"

    fill_in 'phone', with: @user.phone

    click_link '发送验证码'

    fill_in 'verification_code', with: wrong_verification_code
    click_button '登录'

    assert_content '验证码不正确，请重新填写'
  end

  # TODO: 0331 should delete, create page change.
  # test "create user with phone already registered" do
  #   Account::User.any_instance.stubs(:authenticate_otp).returns( true )
  #
  #   visit "/phone_verification/new"
  #   fill_in 'phone', with: @user.phone
  #   fill_in 'password', with: @user.password
  #   fill_in 'password_confirmation', with: @user.password_confirmation
  #
  #   click_link '发送验证码'
  #   # fill_in 'verification_code', with: "123456"
  #   # click_button '注册'
  #   # assert_content '电话号码 已被使用'
  #   assert_content '此号码已注册，请重新填写'
  # end

  # test "create user with diff password" do
  #   Account::User.any_instance.stubs(:authenticate_otp).returns( true )
  #   Qcloud::Sms.stubs(:single_sender).returns(true)
  #
  #   new_phone = "12345678900"
  #   diff_pw = @user.password + "1"
  #
  #   visit "/phone_verification/new"
  #   fill_in 'phone', with: new_phone
  #   fill_in 'password', with: @user.password
  #   fill_in 'password_confirmation', with: diff_pw
  #
  #   click_link '发送验证码'
  #
  #   fill_in 'verification_code', with: "123456"
  #   click_button '注册'
  #
  #   assert_content '密码不匹配，请重新输入'
  # end

  # TODO: 0331 should delete, create page change.
  # test "create user with wrong verification_code" do
  #   Qcloud::Sms.stubs(:single_sender).returns(true)
  #
  #   new_phone = "12345678900"
  #
  #   visit "/phone_verification/new"
  #   fill_in 'phone', with: new_phone
  #   fill_in 'password', with: @user.password
  #   fill_in 'password_confirmation', with: @user.password
  #
  #   click_link '发送验证码'
  #
  #   fill_in 'verification_code', with: @fake_verification_code
  #   click_button '注册'
  #
  #   assert_content '验证码不正确，请重新填写'
  # end

  # test "create user with right params" do
  #   Account::User.any_instance.stubs(:authenticate_otp).returns( true )
  #   Qcloud::Sms.stubs(:single_sender).returns(true)
  #
  #   new_phone = "12345678900"
  #
  #   visit "/phone_verification/new"
  #   fill_in 'phone', with: new_phone
  #   fill_in 'password', with: @user.password
  #   fill_in 'password_confirmation', with: @user.password
  #
  #   click_link '发送验证码'
  #
  #   fill_in 'verification_code', with: @fake_verification_code
  #   click_button '注册'
  #
  #   assert_content '用户注册成功'
  #   assert_equal 2, Account::User.count
  # end

end
