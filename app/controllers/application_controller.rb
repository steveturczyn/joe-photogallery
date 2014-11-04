class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_sorted_pictures
    @sorted_pictures = Picture.user_representations
  end

  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end
end
