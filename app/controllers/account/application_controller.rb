module Account
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?

    if respond_to?(:helper_method)
      helpers = %w(login_corp_name)
      helper_method(*helpers)
    end

    protected

    def configure_permitted_parameters
      added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def login_corp_name
      @login_corp_name ||= Account.login_corp_name
    end

  end
end
