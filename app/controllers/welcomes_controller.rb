class WelcomesController < ApplicationController

  def index
    get_sorted_pictures
    @pictures = get_sorted_pictures.dup
    @picture = Picture.find_by(id: params[:id]) || @pictures.sample
    @show_user = @picture.user
    @sorted_pictures.each do |picture|
      break if picture == @picture
      @pictures.push(@pictures.shift)
    end

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
