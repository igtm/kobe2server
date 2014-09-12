class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :name
      t.string :category
      t.text :description
      t.integer :favorite_count
      t.string :img_url
      t.string :site_url

      t.timestamps
    end
  end
end
