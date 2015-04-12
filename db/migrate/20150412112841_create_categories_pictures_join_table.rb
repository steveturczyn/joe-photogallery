class CreateCategoriesPicturesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :categories, :pictures do |t|
      # t.index [:category_id, :picture_id]
      # t.index [:picture_id, :category_id]
    end
  end
end
