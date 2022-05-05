
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["WECHAT_TEST_APP_ID"], ENV["WECHAT_TEST_APP_SECRET"],
   :client_options => {
        site:          "https://api.weixin.qq.com",
        # authorize_url: "https://open.weixin.qq.com/connect/oauth2/authorize?#wechat_redirect",
        # 返回code与state，OmniAuth use code to get wechat info and redirect to /auth/wechat/callback
        authorize_url: "https://www.sflx.com.cn/get-weixin-code.html?#wechat_redirect",
        token_url:     "/sns/oauth2/access_token",
        token_method:  :get
      },
   :authorize_params => {:scope => "snsapi_userinfo"}
  # test account
  # provider :wechat, ENV["WECHAT_TEST_APP_ID"], ENV["WECHAT_TEST_APP_SECRET"], :authorize_params => {:scope => "snsapi_base"}

end
