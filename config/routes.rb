Account::Engine.routes.draw do
  devise_for :users, module: 'devise', class_name: "Account::User"
  devise_for :admins, module: 'devise', class_name: "Account::Admin"

  # get "/auth/wechat/callback" => "authentications#wechat"
  get "/auth/:action/callback", :controller => "user/wechat", :constraints => { :action => /wechat/ }
end
