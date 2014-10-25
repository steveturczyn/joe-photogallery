class BiosController < ApplicationController

  before_filter :get_sorted_pictures

  def index
    @show_user = User.find_by(id: params[:user_id])
  end
end
