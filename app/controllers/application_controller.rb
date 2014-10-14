class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_sorted_pictures
    @sorted_pictures = Picture.select {|picture| picture.represent_user? }.sort_by {|p| p.user.last_name }
  end

end
