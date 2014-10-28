class RegistrationsController < Devise::RegistrationsController
  before_action :get_sorted_pictures
end 