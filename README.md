# Account
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'account'
```

## Usage

copy template/devise.rb to your application: admin_engine/config/initializer/devise.rb || config/initializer/devise.rb.

```ruby
mount Account::Engine   => '/', as: 'account'
```
Add account gem routes to your app/config/routes.rb.

for wechat omniauth
copy template/omniauth.rb to your application: config/initializer/omniauth.rb.

<!-- copy db/migrate to your application. -->
```bash
$ rails db:migrate
```

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
