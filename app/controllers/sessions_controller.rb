class SessionsController < Devise::SessionsController
  def new
    get_sorted_pictures
    super
  end
end 