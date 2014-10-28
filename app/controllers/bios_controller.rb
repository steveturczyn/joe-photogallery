class BiosController < ApplicationController

  before_action :get_sorted_pictures

  def index
    @show_user = User.find_by(id: params[:user_id])
  end
end
