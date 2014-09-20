class CreateVarieties < ActiveRecord::Migration
  def change
    create_table :varieties do |t|
      t.string :title
      t.string :category
      t.text :content
      t.integer :favorite_count
      t.boolean :imageFlag
      t.string :image
      t.string :site_url

      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :distance_km

      t.timestamps
    end
  end
end
