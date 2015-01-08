class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  @@logged_off_user = nil

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :categories, -> { order(:name) }, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def bio_or_default
    if bio.blank?
      "#{first_name} #{last_name} hasn't entered any biographical information yet."
    else
      bio
    end
  end

  def self.save_logged_off_user(user)
    @@logged_off_user = user
  end

  def self.retrieve_logged_off_user
    @@logged_off_user
  end

  def has_pictures?
    self.categories.map{|category| category.pictures }.flatten != []
  end

  def has_no_pictures?
    !has_pictures?
  end
end
