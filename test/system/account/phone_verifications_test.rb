require "application_system_test_case"

class PhoneVerificationsTest < ApplicationSystemTestCase
  def setup
    @user = create_user
    @template_code = "276826"
    @phone = @user.phone
  end



  test "phone_verification_new with right phone, same phone of create_user, right otp" do
    verification_code = @user.otp_code.to_s
    params = [verification_code, Account::PhoneVerificationController::DRIFT_MINUTES.to_s]

    # mock send sms.
    # Qcloud::Sms.single_sender(phone, @template_code, params)
    Qcloud::Sms.expects(:single_sender).with(@phone, @template_code, params).returns(true)

    # mock after_sign_in_path_for
    # Account::PhoneVerificationController.any_instance.stubs(:after_sign_in_path_for).returns(user_views_path)
    visit "/phone_verification/new"
    sleep 4
    fill_in 'verification_phone', with: @phone

    sleep 4
    click_link '发送验证码'

    fill_in 'verification_code', with: verification_code
    click_button '登录'

    assert_content '用户登录成功'

  end

  test "phone_verification_new with wrong phone number" do
    short_phone = "123"

    visit "/phone_verification/new"
    sleep 2
    fill_in 'verification_phone', with: short_phone

    sleep 2
    click_link '发送验证码'

    assert_content '号码格式不正确'
  end

  test "phone_verification_new with diff phone of create_user" do
    diff_phone = "12345678900"

    visit "/phone_verification/new"
    sleep 2
    fill_in 'verification_phone', with: diff_phone
    sleep 2
    click_link '发送验证码'

    assert_content '此号码未注册用户，请重新填写'
  end

  test "phone_verification_new with same phone of create_user, but wrong otp" do
    wrong_verification_code = "123456"

    visit "/phone_verification/new"
    sleep 2
    fill_in 'verification_phone', with: @phone
    sleep 2
    click_link '发送验证码'

    fill_in 'verification_code', with: wrong_verification_code
    click_button '登录'

    assert_content '验证码不正确，请重新填写'
  end

end
