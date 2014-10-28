class PasswordsController < Devise::PasswordsController
  before_action :get_sorted_pictures
end 