class Picture < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  validates_presence_of :title, :location, :description, :category_id, :image_link

  def user
    category.user
  end

  def self.user_representations
    select {|picture| picture.represent_user? }.sort_by {|p| p.user.last_name }
  end

  def self.set_represent_category_to_false(category_id)
    picture = select {|picture| picture.represent_category == true && picture.category_id == category_id.to_i }.first
    picture.represent_category = false
    picture.save
  end

  def self.set_represent_user_to_false(current_user_id)
    picture = select {|picture| picture.category.user_id == current_user_id && picture.represent_user }.first
    picture.represent_user = false
    picture.save
  end
end