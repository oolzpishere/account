module Account
  class Identify < ApplicationRecord
    self.table_name = 'identifies'
    belongs_to :user
  end
end
