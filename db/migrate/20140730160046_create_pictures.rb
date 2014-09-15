class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.string :location
      t.text :description
      t.string :image_link
      t.integer :category_id
    end
  end
end
