class WelcomesController < ApplicationController

  def index
    get_sorted_pictures
    
    @picture = Picture.find_by(id: params[:id]) || @sorted_pictures.sample
    @photographer_first_name = @picture.user.first_name
    @photographer_last_name = @picture.user.last_name
    @photographer = "#{@photographer_first_name} #{@photographer_last_name}"
    session[:user_id] = @picture.user.id
    session[:photographer] = @photographer
    session[:photographer_first_name] = @photographer_first_name

    prev_photographer
    next_photographer
  end

  private

  def prev_photographer
    @prev_picture = @sorted_pictures[@sorted_pictures.find_index(@picture)-1] || @sorted_pictures.last
    first_name = @prev_picture.user.first_name
    last_name = @prev_picture.user.last_name
    @prev_photographer = "#{first_name} #{last_name}"
  end

  def next_photographer
    @next_picture = @sorted_pictures[@sorted_pictures.find_index(@picture)+1] || @sorted_pictures.first
    first_name = @next_picture.user.first_name
    last_name = @next_picture.user.last_name
    @next_photographer = "#{first_name} #{last_name}"
  end

end
