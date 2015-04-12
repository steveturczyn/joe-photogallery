class RemoveCategoryIdFromPicturesTable < ActiveRecord::Migration
  def up
    remove_column :pictures, :category_id
  end
  def down
    add_column :pictures, :category_id, :integer
  end
end
