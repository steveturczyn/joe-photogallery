class Welcome < ActiveRecord::Base

  mount_uploader :url_sm, SmallUploader

end