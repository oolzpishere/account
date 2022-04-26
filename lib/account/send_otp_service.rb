module Account
  class SendOtpService
    DRIFT_MINUTES = 15
    DRIFT_SECOND = 60 * DRIFT_MINUTES
    TEMPLATE_CODE = "276826"
    
    attr_reader :phone, :session, :status, :user_params
    def initialize(phone, status, user_params, session: nil)
      @phone = phone
      @session = session
      @status = status
      @user_params = user_params
    end

    def send
      user = find_or_new_user
      return if user.blank?

      result = send_sms( phone, user.otp_code ) ? true : false
      status[:result] = result
      if Rails.env.test?
        File.write("#{Rails.root}/tmp/test_otp_code", user.otp_code)
      end
      status
    end

    private

    def find_or_new_user
      user = user_find_by_phone(phone)
      if user
        user
      else
        new_user
      end
    end

    def user_find_by_phone(phone)
      Account::User.find_by(phone: phone) if validate_phone(phone)
    end

    def validate_phone(phone)
      (phone && phone.match(/^[0-9]{11}$/)) ? phone : false
    end

    def send_sms(phone, otp_code, drift = DRIFT_MINUTES.to_s)
      # 验证码：{1}，此验证码{2}分钟内有效，请尽快完成验证。 提示：请勿泄露验证码给他人
      params = [otp_code, drift]

      return if Rails.env.development?

      if Qcloud::Sms.single_sender(phone, TEMPLATE_CODE, params)
        return true
      else
        return false
      end
    end

    def new_user
      # return nil, if create! fail
      user = Account::User.new(user_params)

      i = Devise.friendly_token[0,20]
      user.email = "#{i}@sflx.com.cn"

      if user.password.blank? && user.password_confirmation.blank?
        password = Devise.friendly_token[0,20]
        user.password = password
        user.password_confirmation = password
      end

      if user.save
        user
      else
        false
      end
    end

    # def new_user_with_session_otp
    #   # return nil, if create! fail
    #   user = Account::User.new(user_params)

    #   i = Devise.friendly_token[0,20]
    #   user.email = "#{i}@sflx.com.cn"

    #   if user.password.blank? && user.password_confirmation.blank?
    #     password = Devise.friendly_token[0,20]
    #     user.password = password
    #     user.password_confirmation = password
    #   end

    #   if session && session["otp_random_secret"]
    #     user.otp_secret_key = session.delete("otp_random_secret")
    #   else
    #     user.otp_secret_key = Account::User.otp_random_secret
    #     session["otp_random_secret"] = user.otp_secret_key
    #   end
    #   user
    # end

    

  end
end
