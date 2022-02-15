source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in account.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  # Use Puma as the app server
  gem 'puma', '~> 3.11'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'

  gem 'mocha'
  gem 'capybara'
  # download the exact version with your chromebrowser, don't user gem:webdriver.
  gem 'selenium-webdriver'

  # gem 'rspec-rails'
  # guard detect chang need gem install rb-fsevent
  # gem 'guard-rspec', require: false
  gem 'factory_bot_rails'
  # gem 'rails-controller-testing'
  gem 'faker'

  gem 'awesome_print'
  # gem 'better_errors'

  gem 'tapping_device'
end
