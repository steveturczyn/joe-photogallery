class SessionsController < Devise::SessionsController
  before_action :get_sorted_pictures

  # def destroy
  #   @@user = current_user
  #   binding.pry
  #   signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
  #   set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
  #   yield if block_given?
  #   respond_to_on_destroy
  # end
end 