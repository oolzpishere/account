Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["SFLX_WECHAT_OPEN_ID"], ENV["SFLX_WECHAT_OPEN_SE"],
      # :authorize_params => {:scope => "snsapi_userinfo"},
      :client_options => {authorize_url: "https://www.sflx.com.cn/get-weixin-code.html"}
  
  provider :open_wechat, ENV["SFLX_WECHAT_OPEN_ID"], ENV["SFLX_WECHAT_OPEN_SE"]
  # if you want to skip CORS verification, uncomment this line:
  # provider :open_wechat, ENV["SFLX_WECHAT_OPEN_ID"], ENV["SFLX_WECHAT_OPEN_SE"], provider_ignores_state: true
end

# https://github.com/omniauth/omniauth/issues/1025
# https://github.com/omniauth/omniauth/wiki/Upgrading-to-2.0
# For bug: (wechat) Authentication failure! authenticity_error: OmniAuth::AuthenticityError, ForbiddenAccount
OmniAuth.config.request_validation_phase = Account::TokenVerifier.new