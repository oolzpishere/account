module Account
  class User < ApplicationRecord
    include ActiveModel::Validations
    self.table_name = 'users'
    has_many :identifies, dependent: :destroy
    # gem:active_model_otp
    has_one_time_password

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, authentication_keys: [:login]

    validate :must_have_one

    def must_have_one
     errors.add(:base, 'Must have phone or email') unless (phone? || email?)
    end

    validates :email, uniqueness: { case_sensitive: false }, allow_nil: true, allow_blank: true
    validates :phone, uniqueness: true, allow_nil: true, allow_blank: true
    validates_format_of :phone, with: /\A[0-9+_-]+\z/
    # https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    def phone?
     !phone.blank?
    end

    def email?
     !email.blank?
    end
    # https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-with-something-other-than-their-email-address
    def email_required?
     false
    end

    def email_changed?
      false
    end

    # <10 login with phone and email
    attr_writer :login

    def login
     # @login || self.phone || self.email
    end

    # function to handle user's login via email or phone
    def self.find_first_by_auth_conditions(warden_conditions)
      # conditions = warden_conditions.dup
      # login = conditions.delete(:login)
      login = warden_conditions[:login]

      if is_phone_number(login)
        where(phone: login).first
      elsif is_email_address(login)
        where(email: login).first
      else
        nil
      end
      # if login = conditions.delete(:login)
      #   where(conditions).where(["phone = :value OR lower(email) = :value", { :value => login.downcase }]).first
      # else
      #   if conditions[:phone].nil?
      #     where(conditions).first
      #   else
      #     where(phone: conditions[:phone]).first
      #   end
      # end
    end
    # <!10

    private

    def self.is_phone_number(str)
      str.match(/\A[0-9+_-]+\z/)
    end

    def self.is_email_address(str)
      str.match(/.+@.+/)
    end

  end
end
