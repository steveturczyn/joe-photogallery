class Picture < ActiveRecord::Base

  belongs_to :category

  has_one :represents_user, class_name: "User", foreign_key: "picture_id"

  has_one :represents_category, class_name: "Category", foreign_key: "picture_id"

  delegate :user, to: :category

  mount_uploader :image_link, MyUploader

  validates :title, :location, :description, :category_id, :image_link, presence: true

  validate :first_picture_must_represent_user
  validate :represent_user_must_represent_category
  validate :there_must_be_one_picture_representing_user
  validate :first_picture_in_category_must_represent_category

  before_save :fix_represent_user
  before_save :fix_represent_category

  after_destroy :remove_directory

  attr_accessor :set_cat_picture
  attr_accessor :set_user_picture

  after_initialize :set_representative_booleans

  def represent_user_must_represent_category
    if represents_user && !represents_category
      errors.add(:represents_category, "Since your picture represents this user, it must also represent this category.")
    end
  end

  def there_must_be_one_picture_representing_user
    return unless category
    return if !set_user_picture && !set_cat_picture
    if !set_user_picture && (user.representative_picture == nil || (user.representative_picture.category == category && user.representative_picture != self))
        errors.add(:represents_user, "A picture must represent a user.")
    end
  end

  def first_picture_must_represent_user
    return unless category
    if category.user.pictures.empty?
      if !represents_user
        errors.add(:represents_user, "Your first picture must represent the user.")
      end
    end
  end

  def first_picture_in_category_must_represent_category
    return unless category
    if category.pictures.empty?
      if !represents_category
        errors.add(:represents_category, "This picture must represent the category.")
      end
    end
  end

  def user
    category.user
  end

  def self.user_representations
    User.all.map(&:representative_picture).select{ |p| p}.sort_by{ |p| p.user.last_name }
  end

  def remove_directory
    FileUtils.remove_dir (image_link.store_dir), force: true
  end

  def set_representative_booleans
    self.set_cat_picture = !!represents_category
    self.set_user_picture = !!represents_user
  end

  def fix_represent_user
    category.user.representative_picture = self if set_user_picture
    category.user.save
  end

  def fix_represent_category
    category.representative_picture = self if set_cat_picture
    category.save
  end
end