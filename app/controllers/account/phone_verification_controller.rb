module Account
  class PhoneVerificationController < Account::ApplicationController
    protect_from_forgery only: []
    # skip_before_action :authenticate_user!
    # layout "account/application.html.erb"

    # default otp-code available for 30 second, drift: 60, is add 60 second more available time.
    # drift 5 minutes.

    def login

    end

    def new

    end

    def create
    end

    def send_verification
      notifier = Account::Notifier.new

      phone_num = phone_params[:phone]
      # user_action = phone_params[:user_action]

      unless phone = validate_phone( phone_num )
        notifier.add_error(:invalid_phone_number, '号码格式不正确')
      end

      result = send_otp_service(phone_num, notifier)
      
      respond_to do |format|
        format.json  { render :json => { result: result, error_message: notifier.full_messages } }
      end
    end

    def check_verification_code
      phone_num = phone_params[:phone]
      verification_code = verification_params[:verification_code]

      unless phone = validate_phone( phone_num )
        redirect_to( account.user_session_path, alert: '号码格式不正确' )
        return
      end

      user = user_find_by_phone(phone)
      unless user.authenticate_otp( verification_code, drift: Account::SendOtpService::DRIFT_SECOND )
        redirect_to( account.user_session_path, alert: '验证码不正确，请重新填写' )
        return
      end

      sign_in user, :event => :authentication, scope: :user

      # redirect_to after_sign_in_path_for(Account::User), notice: '用户登录成功'
      redirect_to "/users", notice: '用户登录成功'

    end

    private
      # don't need to use yet.
      def phone_params
        # params.fetch(:user, {}).permit(:phone, :password, :password_confirmation, :user_action)
        params.fetch(:phone, {}).permit(:phone, :password, :password_confirmation)
      end

      def verification_params
        params.fetch(:phone, {}).permit(:verification_code)
      end

      def phone_login_path
        account.phone_verification_login_path
      end

      def created_user?(phone)
        !!user_find_by_phone(phone)
      end

      def user_find_by_phone(phone)
        Account::User.find_by(phone: phone) if validate_phone(phone)
      end

      def validate_phone(phone)
        (phone && phone.match(/^[0-9]{11}$/)) ? phone : false
      end

      def new_user_with_session_otp
        # return nil, if create! fail
        user = Account::User.new(phone_params)

        i = Devise.friendly_token[0,20]
        user.email = "#{i}@sflx.com.cn"

        if user.password.blank? && user.password_confirmation.blank?
          password = Devise.friendly_token[0,20]
          user.password = password
          user.password_confirmation = password
        end

        if session["otp_random_secret"]
          user.otp_secret_key = session.delete("otp_random_secret")
        else
          user.otp_secret_key = Account::User.otp_random_secret
          session["otp_random_secret"] = user.otp_secret_key
        end
        user
      end

      def find_or_new_user_erab(phone)
        user = user_find_by_phone(phone)
        if user
          user
        else
          new_user_with_session_otp
        end
      end

      def save_user_erab(user)
        return user if user.persisted?

        if user.save
          user
        else
          # save user fail.
          new_status[:error] = '创建用户失败，请重新验证'
          return false
        end
      end

      def compare_otp_erab(user)
        unless user.authenticate_otp(verification_params[:verification_code], drift: Account::SendOtpService::DRIFT_SECOND)
          new_status[:error] = '验证码不正确，请重新填写'
          return false
        else
          return true
        end
      end

      def send_otp_service(phone, notifier)
        return false if notifier.any_error?
        Account::SendOtpService.new( phone, notifier, phone_params, session: session ).send
      end

      def new_status
        @new_status ||= {}
      end

  end
end
