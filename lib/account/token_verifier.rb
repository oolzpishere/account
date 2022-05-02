# https://github.com/omniauth/omniauth/issues/1025
# https://github.com/omniauth/omniauth/wiki/Upgrading-to-2.0
# For bug: (wechat) Authentication failure! authenticity_error: OmniAuth::AuthenticityError, ForbiddenAccount

module Account
  class TokenVerifier
    include ActiveSupport::Configurable
    include ActionController::RequestForgeryProtection

    def call(env)
      @request = ActionDispatch::Request.new(env.dup)
      raise OmniAuth::AuthenticityError unless verified_request?
    end

    private
    attr_reader :request
    delegate :params, :session, to: :request
  end
end