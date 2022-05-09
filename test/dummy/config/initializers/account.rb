Account.setup do |config|
  config.phone_login = true
  # config.phone_verification_code_length = 6

  config.omniauth_wechat= true
  config.omniauth_open_wechat= true
end