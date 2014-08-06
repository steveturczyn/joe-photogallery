class Image < ActiveRecord::Base

  # mount_uploader :url_sm, SmallUploader
  # mount_uploader :url_lg, LargeUploader

  validates_presence_of :title, :location, :description, :url_sm, :url_lg, :category_id

end