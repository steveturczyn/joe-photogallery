class Picture < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  validates_presence_of :title, :location, :description, :category_id

  def user
    category.user
  end

  def self.user_representations
    select {|picture| picture.represent_user? }.sort_by {|p| p.user.last_name }
  end
end