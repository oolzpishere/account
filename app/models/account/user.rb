module Account
  class User < ApplicationRecord
    include ActiveModel::Validations
    self.table_name = 'users'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, authentication_keys: [:login]

    validate :must_have_one

    def must_have_one
     errors.add(:base, 'Must have phone or email') unless (phone? || email?)
    end

    validates :email, uniqueness: { case_sensitive: false }
    validates :phone, uniqueness: true
    validates_format_of :phone, with: /\A[0-9_+]*\z/
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
     @login || self.phone || self.email
    end

    # function to handle user's login via email or phone
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["phone = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        if conditions[:phone].nil?
          where(conditions).first
        else
          where(phone: conditions[:phone]).first
        end
      end
    end
    # <!10

  end
end
