require "application_system_test_case"

class PhoneVerificationsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit phone_verifications_url
  #
  #   assert_selector "h1", text: "PhoneVerification"
  # end

  test "can visit phone verification new" do
    user = create_user
    phone = user.phone
    template_code = "276826"
    verification_code = user.otp_code.to_s
    params = [verification_code, Account::PhoneVerificationController::DRIFT_MINUTES.to_s]

    # mock send sms.
    Qcloud::Sms.expects(:single_sender).with(phone, template_code, params).returns(true)
    # Qcloud::Sms.single_sender(phone, template_code, params)

    # mock after_sign_in_path_for
    # Account::PhoneVerificationController.any_instance.stubs(:after_sign_in_path_for).returns(user_views_path)

    visit "/phone_verification/new"
    # assert_response :success
    sleep 2
    fill_in 'verification_phone', with: phone

    sleep 2
    click_link '发送验证码'

    fill_in 'verification_code', with: verification_code
    click_button '登录'

    assert_content '用户登录成功'

  end

  # test "test helper" do
  #   user = create_user
  #   assert_equal user, Account::User.first
  # end


end
