module Account
  class PhoneVerificationController < Account::ApplicationController
    protect_from_forgery only: []
    # skip_before_action :authenticate_user!
    # layout "account/application.html.erb"

    # default otp-code available for 30 second, drift: 60, is add 60 second more available time.
    # drift 5 minutes.
    DRIFT_MINUTES = 5
    DRIFT_SECOND = 60 * DRIFT_MINUTES
    TEMPLATE_CODE = "276826"

    def login

    end

    def new

    end

    def create
      status = {:result => false}
      phone_num = user_params[:phone]
      verification_code = user_params[:verification_code]

      unless phone = validate_phone( phone_num )
        status[:error_message] = "号码格式不正确"
      end

      if status[:error_message].blank?
        if user_find_by_phone(phone)
          status[:error_message] = '此号码已注册，请重新输入'
        end
      end

      if status[:error_message].blank?
        password = user_params[:password]
        password_confirmation = user_params[:password_confirmation]
        unless Devise.secure_compare(password, password_confirmation)
          status[:error_message] = '密码不匹配，请重新输入'
        end
      end

      if status[:error_message].blank?
        user = new_user
        unless user.authenticate_otp(verification_code, drift: DRIFT_SECOND.to_s)
          status[:error_message] = '验证码不正确，请重新填写'
        end
      end

      if status[:error_message].blank?
        unless user.save
          status[:error_message] = '用户注册失败'
        end
      end

      if status[:error_message]
        redirect_to( phone_registration_path, alert: status[:error_message] )
      else
        sign_in user, :event => :authentication, scope: :user
        redirect_to after_sign_in_path_for(Account::User), notice: '用户注册成功'
      end
    end

    def send_verification
      status = {:result => false}
      phone_num = params[:phone]
      user_action = params[:user_action]

      unless phone = validate_phone( phone_num )
        status[:error_message] = "号码格式不正确"
      end

      status = if create_user?(user_action)
        create_user_send_proc(phone_num, status)
      else
        login_user_send_proc(phone_num, status)
      end

      respond_to do |format|
        format.json  { render :json => status}
      end
    end

    def check_verification_code
      #d data = {:result => false}
      phone_num = user_params[:phone]
      verification_code = user_params[:verification_code]

      unless phone = validate_phone( phone_num )
        redirect_to(phone_login_path, alert: '号码格式不正确')
        return false
      end

      unless user = user_find_by_phone(phone)
        redirect_to(phone_login_path, alert: '此号码未注册用户，请重新填写')
        return false
      end

      if user.authenticate_otp(verification_code, drift: DRIFT_SECOND)
        sign_in user, :event => :authentication, scope: :user
        redirect_to after_sign_in_path_for(Account::User), notice: '用户登录成功'
      else
        redirect_to(phone_login_path, alert: '验证码不正确，请重新填写')
      end
    end

    private
      # don't need to use yet.
      def user_params
        params.fetch(:user, {}).permit(:phone, :verification_code, :password, :password_confirmation)
      end

      def phone_login_path
        account.phone_verification_login_path
      end

      def phone_registration_path
        account.phone_verification_new_path
      end

      def user_find_by_phone(phone)
        Account::User.find_by(phone: phone) if validate_phone(phone)
      end

      def validate_phone(phone)
        (phone && phone.match(/^[0-9]{11}$/)) ? phone : false
      end

      def new_user
        i = Devise.friendly_token[0,20]
        # return nil, if create! fail
        user = Account::User.new(user_params)
        user.email = "#{i}@sflx.com.cn"
        user.otp_random_secret = session.delete("otp_random_secret")
        user
      end

      def create_user?(user_action)
        user_action && user_action.match("create")
      end

      def create_user_send_proc(phone, status)
        if status[:error_message].blank?
          if user_find_by_phone(phone)
            status[:error_message] = '此号码已注册，请重新填写'
          end
        end

        if status[:error_message].blank?
          otp_random_secret = Account::User.otp_random_secret
          session["otp_random_secret"] = otp_random_secret

          result = send_sms( phone, otp_random_secret ) ? true : false
          status[:result] = result
        end
        status
      end

      def login_user_send_proc(phone, status)
        if status[:error_message].blank?
          unless user = user_find_by_phone(phone)
            status[:error_message] = '此号码未注册用户，请重新填写'
          end
        end

        if status[:error_message].blank?
          result = send_sms( phone, user.otp_code.to_s) ? true : false
          status[:result] = result
        end
        status
      end

      def send_sms(phone, otp_code, drift = DRIFT_MINUTES.to_s)
        # 验证码：{1}，此验证码{2}分钟内有效，请尽快完成验证。 提示：请勿泄露验证码给他人
        params = [otp_code, drift]

        if Qcloud::Sms.single_sender(phone, TEMPLATE_CODE, params)
          return true
        else
          return false
        end
      end

  end
end
