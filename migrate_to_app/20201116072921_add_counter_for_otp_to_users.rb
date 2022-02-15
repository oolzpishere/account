class AddCounterForOtpToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :otp_counter, :integer
  end
end
