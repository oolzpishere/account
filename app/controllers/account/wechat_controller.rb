
module Account
  class WechatController < ::ActionController::Base
    # skip_before_action :verify_authenticity_token, only: :wechat
    # skip_before_action :authenticate_user!
    # not authenticate_user! when callback to wechat.

    before_action :get_info
    # set class vars after get_info success.
    attr_reader :auth_info, :wechat_user_info, :raw_info, :provider, :openid , :unionid

    def wechat
      @wechat_user_info = auth_info.info  # https://github.com/skinnyworm/omniauth-wechat-oauth2
      @raw_info = auth_info.extra[:raw_info]
      @provider = auth_info.provider
      @openid = auth_info.uid
      @unionid = raw_info["unionid"] ? raw_info["unionid"] : ""

      if identify = find_identify
        # exist, get user data from db.
        @user = identify.user
      else
        # not exist, create user.
        @user = create_user_and_identify
        return false unless @user
      end

      # sign_in_and_redirect @user, :event => :authentication
      sign_in @user, :event => :authentication, scope: :user
      # TODO: consider how to add this setting to difference App.
      # 1. Add to initialze config file.
      # TODO: redirect to session[devise_after_sign_in] || user home page.
      redirect_to after_sign_in_path_for(Account::User)
    end

    private

    def login_path
      account.new_user_session_path
    end

    def get_info
      if @auth_info = request.env['omniauth.auth']       # 引入回调数据 HASH
        return @auth_info
      else
        # TODO: get omniauth.auth fail, return to login page
        redirect_to(login_path, alert: 'omniauth.auth wechat未返回正确数据')
        return false
      end
    end

    # find user by unionid first.
    def find_identify
      identify = nil
      unless unionid.blank?
        identify = Account::Identify.find_by(provider: provider, unionid: unionid)
        return identify if identify
      end

      unless openid.blank?
        identify = Account::Identify.find_by(provider: provider, uid: openid)
      end
      return identify
    end

    def create_user_and_identify
      i = Devise.friendly_token[0,20]
      # return nil, if create! fail
      new_user = Account::User.new(
        # username: wechat_user_info.nickname.to_s,
        username: wechat_user_info.nickname.to_s + "_" + rand(36 ** 3).to_s(36),
        email:  "#{i}@sflx.com.cn",       # 因为devise 的缘故,邮箱暂做成随机
        avatar: wechat_user_info.headimgurl,
        password: i,                                              # 密码随机
        password_confirmation: i
      )
      unless new_user.save
        # TODO: redirect_to login_path || root_path
        redirect_to(login_path, alert: 'user保存错误')
        return false
      end
      return false unless create_identify(new_user)
      new_user
    end

    def create_identify(user)
      identify = Account::Identify.new(
        provider: auth_info.provider,
        uid: auth_info.uid,
        unionid: unionid,
        user_id: user.id
      )
      unless identify.save
        # TODO: redirect_to login_path || root_path
        redirect_to(login_path, alert: 'identify保存错误')
        return false
      end
      identify
    end

  end
end
