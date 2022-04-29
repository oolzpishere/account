module Account
  class SendOtpService
    DRIFT_MINUTES = 15
    DRIFT_SECOND = 60 * DRIFT_MINUTES
    # TEMPLATE_CODE = "276826"
    
    attr_reader :phone, :session, :notifier, :user_params
    def initialize(phone, notifier, user_params, session: nil)
      @phone = phone
      @session = session
      @notifier = notifier
      @user_params = user_params
    end

    def send
      user = find_or_create_user
      raise 'find_or_create_user fail.' if user.blank?

      send_sms( phone, user.otp_code )
    end

    private

    def find_or_create_user
      user = user_find_by_phone(phone)
      if user
        user
      else
        create_user
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

      if Rails.env.development?
        Rails.logger.info "!!send_sms: #{phone}, #{params.join(', ')}"
        return
      end
      
      if Qcloud::Sms.single_sender(phone, Account.verify_template_code, params)
        return true
      else
        notifier.add_error(:send_sms_fail, "发送验证码失败，请点击重新发送")
        return false
      end
    end

    def create_user
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
        # report to developer
        # return to this action starting point and tell user to try again.
        notifier.add_error(:create_user_fail, "创建用户失败，请重新注册")
        false
      end
    end


  end
end
