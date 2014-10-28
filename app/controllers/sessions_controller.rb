class SessionsController < Devise::SessionsController
  before_action :get_sorted_pictures
end 