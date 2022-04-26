require "account/engine"

require "account/send_otp_service"

# require 'bootstrap'
# require 'jquery-rails'

require 'devise'
require 'active_model_otp'

require 'omniauth'
require "omniauth-wechat-oauth2"

require 'qcloud/sms'
require 'aliyun/sms'

module Account
  
  class<< self
    attr_accessor :login_corp_name, :phone_login, :wechat_login

    @phone_login = true
    @wechat_login = true

    def setup
      yield self
    end

  end

end
