class User::ApplicationController < ApplicationController
  before_action :authenticate_user

  private

    def authenticate_user
      unless user_signed_in?
        sign_out :user
        redirect_to account.new_user_session_path, notice: "请使用user账户访问该页面"
      end
    end

end
