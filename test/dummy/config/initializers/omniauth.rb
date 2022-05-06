Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["WECHAT_TEST_APP_ID"], ENV["WECHAT_TEST_APP_SECRET"],
      :authorize_params => {:scope => "snsapi_userinfo"},
      :client_options => {authorize_url: "https://sflx.com.cn/get-weixin-code.html"}
end
# https://github.com/omniauth/omniauth/issues/1025
# https://github.com/omniauth/omniauth/wiki/Upgrading-to-2.0
# For bug: (wechat) Authentication failure! authenticity_error: OmniAuth::AuthenticityError, ForbiddenAccount
OmniAuth.config.request_validation_phase = Account::TokenVerifier.new