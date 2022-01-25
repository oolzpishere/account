Account::Engine.routes.draw do
  if Account::Engine.custom_routes && (Account::Engine.custom_routes == true)
    # class_eval(Account::Engine.custom_routes_draw)
  else
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
    match '/auth/:provider/setup' => '/account/wechat#setup', via: [:get]
    # eg: get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /wechat|google/ }
    get "/auth/wechat/callback", :controller => "/account/wechat", action: "wechat", :constraints => lambda { |request| request.params[:scope].blank? }
    get "/auth/wechat/callback", :controller => "/account/wechat", action: "wechat_base", :constraints => lambda { |request| request.params[:scope] == "snsapi_base" }
  end

end
