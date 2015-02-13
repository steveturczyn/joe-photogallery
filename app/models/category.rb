class Category < ActiveRecord::Base

  belongs_to :user

  has_many :pictures, -> { order ('title') }, dependent: :destroy

  validates :name, :user_id, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :user_id }


end