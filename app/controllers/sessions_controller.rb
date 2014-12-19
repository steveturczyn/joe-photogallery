class SessionsController < Devise::SessionsController
  before_action :get_sorted_pictures

  def destroy
    User.save_logged_off_user(current_user.id)
    super
  end
end 