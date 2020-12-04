require "application_system_test_case"

class PhoneVerificationsTest < ApplicationSystemTestCase
  def setup
    @user = create_user
    @template_code = "276826"
    @phone = @user.phone
  end



  test "phone_verification_new with right phone, same phone of create_user, right otp" do
    fake_verification_code = '123456'
    Account::User.any_instance.stubs(:otp_code).returns( fake_verification_code )
    Account::User.any_instance.stubs(:authenticate_otp).returns( true )

    params = [fake_verification_code, Account::PhoneVerificationController::DRIFT_MINUTES.to_s]

    # mock send sms.
    # Qcloud::Sms.single_sender(phone, @template_code, params)
    Qcloud::Sms.expects(:single_sender).with(@phone, @template_code, params).returns(true)

    # mock after_sign_in_path_for
    # Account::PhoneVerificationController.any_instance.stubs(:after_sign_in_path_for).returns(user_views_path)
    visit "/phone_verification/new"

    fill_in 'verification_phone', with: @phone

    click_link '发送验证码'
    # countDown test
    assert_content '再次发送验证码'
    assert find('#send_verification_code', class: 'disabled')

    using_wait_time 5 do
      fill_in 'verification_code', with: fake_verification_code
    end
    click_button '登录'

    assert_content '用户登录成功'
    assert_content @phone
  end

  test "phone_verification_new with wrong phone number" do
    short_phone = "123"

    visit "/phone_verification/new"

    fill_in 'verification_phone', with: short_phone

    click_link '发送验证码'

    assert_content '号码格式不正确'
  end

  test "phone_verification_new with diff phone of create_user" do
    diff_phone = "12345678900"

    visit "/phone_verification/new"

    fill_in 'verification_phone', with: diff_phone

    click_link '发送验证码'
    # countDown test
    assert_no_text '再次发送验证码'
    assert has_no_css?('#send_verification_code', class: 'disabled')

    assert_content '此号码未注册用户，请重新填写'
  end

  test "phone_verification_new with same phone of create_user, but wrong otp" do
    wrong_verification_code = "654321"

    visit "/phone_verification/new"

    fill_in 'verification_phone', with: @phone

    click_link '发送验证码'

    fill_in 'verification_code', with: wrong_verification_code
    click_button '登录'

    assert_content '验证码不正确，请重新填写'
  end

end
