require "application_system_test_case"

class PhoneVerificationsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit phone_verifications_url
  #
  #   assert_selector "h1", text: "PhoneVerification"
  # end

  test "can visit phone verification new" do
    visit "/phone_verification/new"
    # assert_response :success

    fill_in 'verification_phone', with: '12345678901'
    fill_in 'verification_code', with: '123456'

    assert_contain '此号码未注册用户，请重新填写'

  end

end
