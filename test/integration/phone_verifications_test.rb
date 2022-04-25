require 'test_helper'

class PhoneVerificationsTest < ActionDispatch::IntegrationTest
  def setup

  end

  test "otp_secret_key is the same, opt_code should same, too" do
    same_otp_random_secret = Account::User.otp_random_secret

    user = Account::User.new
    user.otp_secret_key = same_otp_random_secret
    pre_code= user.otp_code

    new_user = Account::User.new
    new_user.otp_secret_key = same_otp_random_secret
    end_code = new_user.otp_code

    assert new_user.authenticate_otp(pre_code)
    assert_equal pre_code, end_code
  end

  test "otp_secret_key not the same." do
    user = Account::User.new
    user.otp_secret_key = Account::User.otp_random_secret
    pre_code= user.otp_code

    new_user = Account::User.new
    new_user.otp_secret_key = Account::User.otp_random_secret
    end_code = new_user.otp_code

    assert_not_equal pre_code, end_code
  end

end
