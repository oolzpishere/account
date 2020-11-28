Rails.application.routes.draw do

  resources :user_views
  root 'user_views#index'
  mount Account::Engine   => '/', as: 'account'

end
