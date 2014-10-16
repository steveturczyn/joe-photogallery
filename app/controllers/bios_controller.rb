class BiosController < ApplicationController

  before_filter :get_sorted_pictures

  def index
    @user = User.find_by(id: session[:user_id])
  end
end
