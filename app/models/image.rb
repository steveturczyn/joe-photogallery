class Image < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  validates_presence_of :title, :location, :description, :image_link, :category_id

end