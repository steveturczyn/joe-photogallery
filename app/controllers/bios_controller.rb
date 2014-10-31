class BiosController < ApplicationController

  before_action :get_sorted_pictures

  def index
    @show_user = User.find(params[:user_id])
  end
end
