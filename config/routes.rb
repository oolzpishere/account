Account::Engine.routes.draw do
  devise_for :users, module: 'devise', class_name: "Account::User"
  devise_for :admins, module: 'devise', class_name: "Account::Admin"
end
