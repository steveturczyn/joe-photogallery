class Image < ActiveRecord::Base

  validates_presence_of :title, :location, :description, :url_sm, :url_lg, :category_id

end