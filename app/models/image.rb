class Image < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  # Run this code if I need to recreate the thumbnails
  # Image.all.each do |image|
  #   image.image_link.recreate_versions!
  # end

  validates_presence_of :title, :location, :description, :category_id, :image_link

end