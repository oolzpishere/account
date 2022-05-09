module Account
  class Notifier

    def messages
      @messages ||= {}
    end

    def full_messages
      if messages.blank?
        nil
      else
        messages.values.join("\n")
      end
    end

    def any_error?
      !messages.blank?
    end

    # @key: symbol, key word.
    # @message: string, message.
    # eg:
    #   @messages=
    #   {:first_name=>["First Name is required."],
    #    :contact_number=>["Contact number is not a number."]
    #   }>
    def add_error(key, message)
      messages[key] = message
      Rails.logger.error "error: #{key.to_s}: #{message}"
    end

  end
end

#     user.errors
# => #<ActiveModel::Errors:0x00007fe42c1650b8
#   @base=
#   #<User:0x00007fe42c1676d8
#   ....
#   ....
#   @details={:first_name=>[{:error=>:blank}], :contact_number=>[{:error=>:not_a_number}]}
#   @messages=
#   {:first_name=>["First Name is required."],
#    :contact_number=>["Contact number is not a number."]
#   }>

# user.errors
# => #<ActiveModel::Errors:0x00007ff5ba2be5a0 @base=#<User id: nil, first_name: nil, last_name: "Example", email: "sam@example.com", contact_number: "abcdefghijk", created_at: nil, updated_at: nil>,
# @errors=[<#ActiveModel::Error attribute=first_name, type=blank, options={}>, <#ActiveModel::Error attribute=contact_number, type=not_a_number, options={:value=>"abcdefghijk"}>]>