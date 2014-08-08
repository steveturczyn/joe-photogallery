class AddImageLinkToImage < ActiveRecord::Migration
  def change
    add_column :images, :image_link, :string
    remove_column :images, :url_sm
    remove_column :images, :url_lg
  end
end
