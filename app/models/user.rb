class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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
end
