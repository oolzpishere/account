require "account/engine"

require 'bootstrap'
require 'jquery-rails'

require 'devise'
require 'active_model_otp'

require 'omniauth'
require "omniauth-wechat-oauth2"

require 'qcloud/sms'
require 'aliyun/sms'

module Account

  class<< self
    attr_accessor :login_corp_name

  end

end
