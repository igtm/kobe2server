class CreateYahoos < ActiveRecord::Migration
  def change
    create_table :yahoos do |t|
      t.string :title
      t.string :categoryDetail
      t.string :category
      t.string :category_disp
      t.float :shoplon
      t.float :shoplat
      t.text :image
      t.boolean :imageFlag
      t.text :uid
      t.float :distance_km
      t.float :rate
      t.integer :rank
      t.string :db_output

      t.timestamps
    end
  end
end
