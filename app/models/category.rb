class Category < ActiveRecord::Base

  belongs_to :user

  has_many :pictures, dependent: :destroy

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name,:case_sensitive => false, scope: :user_id

end