Qcloud::Sms.configure do |config|
  config.app_id = ENV["QYJIUDIAN_SMS_APP_ID"]         # 腾讯云接入ID，在腾讯云控制台申请
  config.app_key = ENV["QYJIUDIAN_SMS_APP_KEY"]       # 腾讯云接入密钥, 在腾讯云控制台申请
  config.sign = '四方连续'
end
