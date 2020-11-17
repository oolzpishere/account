$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "account/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "account"
  spec.version     = Account::VERSION
  spec.authors     = [""]
  spec.email       = [""]
  spec.homepage    = ""
  spec.summary     = ": Summary of Account."
  spec.description = ": Description of Account."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ": Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "sqlite3"

  spec.add_dependency 'jquery-rails'
  # spec.add_dependency 'jquery-ui-rails'
  # spec.add_dependency 'jquery-fileupload-rails'
  spec.add_dependency 'bootstrap'

  spec.add_dependency 'devise'
  spec.add_dependency 'devise-i18n'
  spec.add_dependency 'active_model_otp'

  spec.add_dependency "omniauth"
  spec.add_dependency "omniauth-wechat-oauth2"

  spec.add_dependency 'qcloud-sms', "~> 1.0.1"
  spec.add_dependency 'aliyun-sms'
end
