# Account
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'account'
```

## Usage

1. copy template/devise.rb to your application: admin_engine/config/initializer/devise.rb || config/initializer/devise.rb.

2. Add account gem routes to your app/config/routes.rb.
```ruby
mount Account::Engine   => '/', as: 'account'
```

3. for wechat omniauth
copy template/omniauth.rb to your application: config/initializer/omniauth.rb.

4. copy db/migrate to your application.
```bash
$ rails db:migrate
```

5. add before_action :authenticate_manager, to your ApplicationController
```ruby
def authenticate_manager
  unless admin_signed_in? && (current_admin.role == "admin")
    sign_out :admin
    redirect_to account.new_admin_session_path, notice: "请使用admin账户访问该页面"
  end
end
```

### Info
phone_verification use `fetch`, not support IE.

### Config
Create `config/initializers/account_engine.rb` and put following configurations into it.
I like to put it at admin engine.
```ruby
# eg.
Account::Engine.custom_routes = true
Account::Engine.admin_modle_devise_setting = [:database_authenticatable]
```

If you setting custom_routes = ture, then add following to your routes file.
I like to put it at admin engine routes file.
```ruby
Account::Engine.routes.draw do
  devise_for :admins, module: 'devise', class_name: "Account::Admin", only: :sessions
end
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
# account
