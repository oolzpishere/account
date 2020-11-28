module Account
  class PhoneVerificationController < Account::ApplicationController
    protect_from_forgery only: []
    # skip_before_action :authenticate_user!
    # layout "account/application.html.erb"

    DRIFT_MINUTES = 5

    def new

    end

    def check_verification_code
      #d data = {:result => false}
      phone = validate_phone(params[:verification_phone])
      unless user = user_find_by_phone(phone)
        redirect_to(phone_login_path, alert: '此号码未注册用户，请重新填写')
        return false
      end
      # default otp-code available for 30 second, drift: 60, is add 60 second more available time.
      # drift 5 minutes.
      if user.authenticate_otp(params[:verification_code], drift: (60 * DRIFT_MINUTES))
        data = {:result => true}
        session[:mobile_verified] = true
        session[:validate_phone] = phone
      end

      sign_in user, :event => :authentication, scope: :user
      redirect_to after_sign_in_path_for(Account::User), notice: '用户登录成功'

    end

    def sendverification
      data = {:result => false}
      phone = validate_phone(params[:verification_phone])
      # TODO:  if verification user == false
      # then skip find user.
      unless user = user_find_by_phone(phone)
        data[:error_message] = '此号码未注册用户，请重新填写'
        respond_to do |format|
          format.json  { render :json => data }
        end
        return
      end
      if phone.present?
        # 验证码：{1}，此验证码{2}分钟内有效，请尽快完成验证。 提示：请勿泄露验证码给他人
        params = [user_find_by_phone(phone).otp_code.to_s, DRIFT_MINUTES.to_s]
        template_code = "276826"
        if Qcloud::Sms.single_sender(phone, template_code, params)
          data = {:result => true}
        end
      end
      respond_to do |format|
        format.json  { render :json => data}
      end
    end

    private
      # don't need to use yet.
      # def password_params
      #   params.fetch(:order, {}).permit(:verification_phone, :verification_code, :password, :password_confirmation)
      # end

      def phone_login_path
        account.phone_verification_new_path
      end

      def user_find_by_phone(phone)
        Account::User.find_by(phone: phone) if validate_phone(phone)
      end

      def validate_phone(phone)
        (phone && phone.match(/^[0-9]{11}$/)) ? phone : false
      end

  end
end
