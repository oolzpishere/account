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
  get "/auth/:action/callback", :controller => "/account/wechat", :constraints => { :action => /wechat/ }


end
