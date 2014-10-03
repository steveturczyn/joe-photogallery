class Picture < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  validates_presence_of :title, :location, :description, :category_id

  def user
    category.user
  end

end