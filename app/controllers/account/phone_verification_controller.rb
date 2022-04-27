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
      status = {:result => false}
      phone_num = phone_params[:phone]
      # user_action = phone_params[:user_action]

      unless phone = validate_phone( phone_num )
        status[:error_message] = "号码格式不正确"
      end

      status = send_otp_service(phone_num, status)

      respond_to do |format|
        format.json  { render :json => status }
      end
    end

    def check_verification_code
      #d data = {:result => false}
      phone_num = phone_params[:phone]
      verification_code = verification_params[:verification_code]

      unless phone = validate_phone( phone_num )
        redirect_to(account.user_session_path, alert: '号码格式不正确')
        return
      end

      user = find_or_new_user_erab(phone)

      compare_otp_erab(user) && save_user_erab(user)

      if new_status[:error]
        redirect_to(account.user_session_path, alert: new_status[:error])
        return
      end

      sign_in user, :event => :authentication, scope: :user

      # redirect_to after_sign_in_path_for(Account::User), notice: '用户登录成功'
      redirect_to "/user/user_views", notice: '用户登录成功'

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

      # def phone_registration_path
      #   account.phone_verification_new_path
      # end

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

      def send_otp_service(phone, status)
        if status[:error_message].blank?
          # user = find_or_new_user_erab(phone)
          # otp_random_secret = Account::User.otp_random_secret
          # session["otp_random_secret"] = otp_random_secret
          # session["otp_random_secret"] = user.otp_secret_key

          result = Account::SendOtpService.new( phone, status, phone_params, session: session ).send ? true : false

          status[:result] = result

        end
        status
      end

      def new_status
        @new_status ||= {}
      end

  end
end
