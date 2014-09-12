class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.float :current_lat
      t.float :current_lon
      t.text :favorite_ids

      t.timestamps
    end
  end
end
