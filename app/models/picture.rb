class Picture < ActiveRecord::Base

  belongs_to :category

  delegate :user, to: :category

  mount_uploader :image_link, MyUploader

  validates :title, :location, :description, :category_id, :image_link, presence: true

  validate :represent_user_must_represent_category
  validate :there_must_be_one_picture_representing_user
  validate :first_picture_must_represent_user
  validate :first_picture_in_category_must_represent_category

  before_save :fix_represent_user
  before_save :fix_represent_category

  after_destroy :remove_directory

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
    if self.class.retrieve_pictures_of_user(category.user_id).empty?
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
    self.class.set_represent_category_to_false(self) if represent_category
    true
  end

  def user
    category.user
  end

  def self.category_representation(category)
    picture = where(:represent_category => true).where(:category_id => category.id).first
  end

  def self.user_representations
    where(:represent_user => true).sort_by{ |p| p.user.last_name }
  end

  def self.retrieve_pictures_of_user(current_user_id)
    joins(:category).where("categories.user_id = ?", current_user_id)
  end

  def self.find_pictures_of_category(category_id)
    where(:category_id => category_id)
  end

  def self.set_represent_category_to_false(current_picture)
    if current_picture.id
      picture = where(:represent_category => true).where(:category_id => current_picture.category.id).where("id != ?", current_picture.id).first
    else  
      picture = where(:represent_category => true).where(:category_id => current_picture.category.id).first
    end
    picture.represent_category = false if picture
    picture.save if picture
  end

  def self.set_represent_user_to_false(current_user_id)
    picture = joins(:category).where("categories.user_id = ?", current_user_id).where(:represent_user => true).readonly(false).first
    picture.represent_user = false if picture
    picture.save if picture
  end

  def remove_directory
    FileUtils.remove_dir (image_link.store_dir), force: true
  end
end