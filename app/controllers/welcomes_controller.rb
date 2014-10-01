class WelcomesController < ApplicationController

  def index
    pictures = Picture.select {|picture| picture.represent_user? }
    
    unsorted_pictures = []
    pictures.each do |picture|
      category = Category.find(picture.category_id)
      last_name = User.find(category.user_id).last_name
      first_name = User.find(category.user_id).first_name
      unsorted_pictures << [picture, last_name, first_name]
    end

    @sorted_pictures = unsorted_pictures.sort_by {|item|item[1]}
    @picture = Picture.find_by(id: params[:id]) || @sorted_pictures[0][0]
    category = Category.find(@picture.category_id)
    first_name = User.find(category.user_id).first_name
    last_name = User.find(category.user_id).last_name
    @photographer = "#{first_name} #{last_name}"
    @photographer_first_name = "#{first_name}"
    @photographer_last_name = "#{last_name}"
    session[:user_id] = category.user_id
    
    @sorted_pictures_without_name = []
    @sorted_pictures.each do |sorted_picture|
      @sorted_pictures_without_name << sorted_picture[0]
    end

    prev_photographer
    next_photographer
  end

  private

  def prev_photographer
    @prev_picture = @sorted_pictures_without_name[@sorted_pictures_without_name.find_index(@picture)-1] || @sorted_pictures_without_name.last
    category = Category.find(@prev_picture.category_id)
    first_name = User.find(category.user_id).first_name
    last_name = User.find(category.user_id).last_name
    @prev_photographer = "#{first_name} #{last_name}"
  end

  def next_photographer
    @next_picture = @sorted_pictures_without_name[@sorted_pictures_without_name.find_index(@picture)+1] || @sorted_pictures_without_name.first
    category = Category.find(@next_picture.category_id)
    first_name = User.find(category.user_id).first_name
    last_name = User.find(category.user_id).last_name
    @next_photographer = "#{first_name} #{last_name}"
  end

end
