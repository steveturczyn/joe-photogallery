class Category < ActiveRecord::Base

  belongs_to :user

  belongs_to :representative_picture, class_name: "Picture", foreign_key: "picture_id"

  has_many :pictures, -> { order ('title') }, dependent: :destroy

  validates :name, :user_id, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :user_id }
end