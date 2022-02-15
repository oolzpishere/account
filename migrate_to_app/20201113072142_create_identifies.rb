class CreateIdentifies < ActiveRecord::Migration[5.2]
  def change
    create_table :identifies do |t|
      t.belongs_to :user, index: true
      t.string :provider
      t.string :uid
      t.string :unionid

      t.timestamps
    end
    
    add_index :identifies, :unionid,     unique: true

  end
end
