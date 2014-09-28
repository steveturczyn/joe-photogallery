class RenameRepresentUserColumnInPictures < ActiveRecord::Migration
  def change
    rename_column :pictures, :represnt_user, :represent_user
  end
end
