class Category < ActiveRecord::Base

  belongs_to :user

  has_many :pictures

  validates_presence_of :name
  validates_uniqueness_of :name,:case_sensitive => false, scope: :user_id

end