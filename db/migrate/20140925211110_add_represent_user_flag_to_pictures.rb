class AddRepresentUserFlagToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :represnt_user, :boolean
  end
end
