class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :location
      t.text :description
      t.string :url_sm
      t.string :url_lg
      t.integer :category_id
    end
  end
end
