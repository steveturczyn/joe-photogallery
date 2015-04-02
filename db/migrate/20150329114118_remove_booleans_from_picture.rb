class RemoveBooleansFromPicture < ActiveRecord::Migration
  def up
    remove_column :pictures, :represent_user
    remove_column :pictures, :represent_category
  end
  def down
    add_column :pictures, :represent_user, :boolean
    add_column :pictures, :represent_category, :boolean
  end
end
