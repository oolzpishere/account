Rails.application.routes.draw do
  mount Account::Engine   => '/', as: 'account'

  namespace :user do
    resources :user_views
    root 'user_views#index'
  end
  # get '/user_views', to: 'user_views#index', :as => :user_root

  namespace :manager do
    resources :admin_views
    root 'admin_views#index'
  end

  # root 'user/user_views#index'



end
