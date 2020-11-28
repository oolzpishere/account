# frozen_string_literal: true

require 'active_support/test_case'

class ActiveSupport::TestCase

  def generate_unique_email
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@example.com"
  end

  def valid_attributes(attributes={})
    { email: generate_unique_email,
      # username: "usertest",
      phone: '12345678901',
      password: '12345678',
      password_confirmation: '12345678' }.update(attributes)
  end

  def new_user(attributes={})
    Account::User.new(valid_attributes(attributes))
  end

  def create_user( attributes = {} )
    Account::User.create!(valid_attributes(attributes))
  end

end
