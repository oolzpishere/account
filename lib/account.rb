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
  
  mattr_accessor :admin_module
  @@admin_module = true

  mattr_accessor :user_module
  @@user_module = true

  mattr_accessor :phone_login
  @@phone_login = true

  mattr_accessor :wechat_login
  @@wechat_login = true

  mattr_accessor :verify_template_code
  @@verify_template_code = "276826"

  def self.setup
    yield self
  end

  class<< self
    attr_accessor :login_corp_name
  end

end
