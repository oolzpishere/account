Account::Engine.routes.draw do
  devise_for :users, module: 'devise', class_name: "Account::User"
  devise_for :admins, module: 'devise', class_name: "Account::Admin"

  # get "/auth/wechat/callback" => "authentications#wechat"
  get "/auth/:action/callback", :controller => "user/wechat", :constraints => { :action => /wechat/ }

  get "phone_verification/new", :controller => "/account/phone_verification", :action => "new"
  post :check_verification_code, :controller => "/account/phone_verification", :action => "check_verification_code"
  get :sendverification, :controller => "/account/phone_verification", :action => "sendverification"

end
