require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "account"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.
    config.load_defaults 7.0 


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.


    # config.after_initialize do
    #   Account::User.configure do |klass|
    #     klass.has_many :identifies
    #   end
    # end

  end
end
