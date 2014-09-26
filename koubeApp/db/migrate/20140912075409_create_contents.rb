class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :category
      t.string :category_disp
      t.text :content
      t.integer :favorite_count
      t.string :image
      t.boolean :imageFlag
      t.string :site_url
      
      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :distance_km
      t.timestamps
    end
  end
end
