class PicturesController < ApplicationController

  def show
    get_sorted_pictures

    @sorted_pictures_of_category = Picture.select {|picture| picture.category_id == session[:category_id] }.sort_by {|p| p.id }

    @picture_of_category = Picture.find_by(id: params[:id]) || @sorted_pictures_of_category.first

    prev_picture
    next_picture
  end

  private

  def prev_picture
    @prev_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture_of_category)-1] || @sorted_pictures_of_category.last
  end

  def next_picture
    @next_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture_of_category)+1] || @sorted_pictures_of_category.first
  end

end
