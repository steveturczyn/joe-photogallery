class AddPictureIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :picture_id, :integer
  end
end
