Rails.application.routes.draw do
  namespace :user do
    resources :user_views
    # root 'user_views#index'
  end
  namespace :manager do
    resources :admin_views
    root 'admin_views#index'
  end

  root 'user/user_views#index'


  mount Account::Engine   => '/', as: 'account'

end
