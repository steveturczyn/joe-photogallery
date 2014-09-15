class AddHomeFlagToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :home, :boolean
  end
end