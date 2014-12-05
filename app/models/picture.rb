class Picture < ActiveRecord::Base

  belongs_to :category
  # belongs_to :user

  delegate :user, to: :category

  mount_uploader :image_link, MyUploader

  validates :title, :location, :description, :category_id, :image_link, presence: true

  # validate :title_must_be_unique
  validate :represent_user_must_represent_category
  validate :there_must_be_one_picture_representing_user
  validate :first_picture_must_represent_user
  validate :first_picture_in_category_must_represent_category

  before_save :fix_represent_user
  before_save :fix_represent_category

  # def title_must_be_unique
  #   if !Picture.find_by_title(":title")
  #     errors.add(:title, "You must first delete your existing photo with the title \"#{title}\" before adding a new photo with that title.")
  #   end
  # end

  def represent_user_must_represent_category
    if represent_user && !represent_category
      errors.add(:represent_category, "Since your picture represents this user, it must also represent this category.")
    end
  end

  def there_must_be_one_picture_representing_user
    return unless category
    if !represent_user && represent_category
      other_picture = self.class.category_representation(category)
      if other_picture && other_picture.represent_user && other_picture != self
        errors.add(:represent_user, "A picture must represent a user.")
      end
    end
  end

  def first_picture_must_represent_user
    return unless category
    if self.class.find_pictures_of_user(category.user_id).empty?
      if !represent_user
        errors.add(:represent_user, "Your first picture must represent the user.")
      end
    end
  end

  def first_picture_in_category_must_represent_category
    return unless category
    if self.class.find_pictures_of_category(category_id).empty?
      if !represent_category
        errors.add(:represent_category, "This picture must represent the category.")
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

  def self.category_representation(category)
    picture = select {|picture| picture.represent_category == true && picture.category_id == category.id }.first
  end

  def self.user_representations
    select {|picture| picture.represent_user? }.sort_by {|p| p.user.last_name }
  end

  def self.find_pictures_of_user(current_user_id)
    select {|picture| picture.category.user_id == current_user_id }
  end

  def self.find_pictures_of_category(category_id)
    select {|picture| picture.category_id == category_id }
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