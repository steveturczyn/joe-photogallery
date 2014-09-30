class WelcomesController < ApplicationController

  def index
    @pictures = Picture.select {|picture| picture.represent_user? }
    @picture_photographer = Picture.find_by(id: params[:id]) || @pictures.first
    category = Category.find(@picture_photographer.category_id)
    @photographer = User.find(category.user_id).name
    session[:user_id] = category.user_id

    prev_photographer
    next_photographer
  end

  private

  def prev_photographer
    @prev_picture = @pictures[@pictures.find_index(@picture_photographer)-1] || @pictures.last
    category = Category.find(@prev_picture.category_id)
    @prev_photographer = User.find(category.user_id).name
  end

  def next_photographer
    @next_picture = @pictures[@pictures.find_index(@picture_photographer)+1] || @pictures.first
    category = Category.find(@next_picture.category_id)
    @next_photographer = User.find(category.user_id).name
  end

end
