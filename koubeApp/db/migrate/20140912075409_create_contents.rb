class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :category
      t.text :content
      t.integer :favorite_count
      t.string :image
      t.string :site_url

      t.timestamps
    end
  end
end
