class SavedRecord < ActiveRecord::Base
  belongs_to :user

  serialize :record_json
end
