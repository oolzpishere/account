module Account
  class Admin < ApplicationRecord
    self.table_name = 'admins'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    if Account::Engine.admin_modle_devise_setting
      devise *Account::Engine.admin_modle_devise_setting 
    else
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable
    end

  end
end
