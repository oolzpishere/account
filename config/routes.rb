Account::Engine.routes.draw do
  devise_for :users, module: 'devise', class_name: "Account::User"
  devise_for :admins, module: 'devise', class_name: "Account::Admin"

  # for create account
  get "phone_verification/new", :controller => "/account/phone_verification", :action => "new"
  post "phone_verification/create", :controller => "/account/phone_verification", :action => "create"

  # for login
  get "phone_verification/login", :controller => "/account/phone_verification", :action => "login"
  post :check_verification_code, :controller => "/account/phone_verification", :action => "check_verification_code"

  # send_verification_code sms
  get :send_verification, :controller => "/account/phone_verification", :action => "send_verification"

  # wechat login
  # eg: get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /wechat|google/ }
  get "/auth/wechat/callback", :controller => "/account/wechat", action: "wechat", :constraints => lambda { |request| request.params[:scope].blank? }
  get "/auth/wechat/callback", :controller => "/account/wechat", action: "wechat_base", :constraints => lambda { |request| request.params[:scope] == "snsapi_base" }
  match '/auth/:provider/setup' => '/account/wechat#setup', via: [:get]
  /wechat_base/ }


end
