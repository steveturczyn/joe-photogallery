class RenameHomeColumnInPictures < ActiveRecord::Migration
  def change
    rename_column :pictures, :home, :represent_category
  end
end
