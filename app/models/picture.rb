class Picture < ActiveRecord::Base

  belongs_to :category

  mount_uploader :image_link, MyUploader

  validates_presence_of :title, :location, :description, :category_id, :image_link

  validate :represent_user_must_represent_category
  validate :there_must_be_one_picture_representing_user

  before_save :fix_represent_user
  before_save :fix_represent_category

  def represent_user_must_represent_category
    if represent_user && !represent_category
      errors.add(:represent_category, "Since your picture represents this user, it must also represent this category.")
    end
  end

  def there_must_be_one_picture_representing_user
    if !represent_user && represent_category
      if self.class.user_representation(user) == nil
        errors.add(:represent_user, "A picture must represent a user.")
      end
    end
  end

  def fix_represent_user
    self.class.set_represent_user_to_false(category.user_id) if represent_user
    true
  end

  def fix_represent_category
    self.class.set_represent_category_to_false(category_id) if represent_category
    true
  end

  def user
    category.user
  end

  def self.user_representation(user)
    picture = select {|picture| picture.represent_user == true && picture.category.user == user }.first
  end

  def self.user_representations
    select {|picture| picture.represent_user? }.sort_by {|p| p.user.last_name }
  end

  def self.set_represent_category_to_false(category_id)
    picture = select {|picture| picture.represent_category == true && picture.category_id == category_id.to_i }.first
    picture.represent_category = false if picture
    picture.save if picture
  end

  def self.set_represent_user_to_false(current_user_id)
    picture = select {|picture| picture.category.user_id == current_user_id && picture.represent_user }.first
    picture.represent_user = false if picture
    picture.save if picture
  end
end