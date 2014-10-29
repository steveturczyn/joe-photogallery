class UsersController < ApplicationController

  def show
    get_sorted_pictures

    @show_user = User.find_by(id: params[:id])

    @categories = user_pictures.sort!{|a, b| a.name.downcase <=> b.name.downcase }
    
    @category = Category.find_by(name: params[:cat], user_id: params[:id]) || @categories.first

    @picture = Picture.select{|picture| picture.represent_category }.select{|p| @category.id == p.category_id }.first

    prev_category
    next_category
  end

  private

  def user_pictures
    representational_pictures.select{|category| category.user_id == params[:id].to_i }
  end

  def representational_pictures
    Picture.select{|picture| picture.represent_category }.map{|p| p.category }
  end

  def prev_category
    category = @categories[@categories.find_index(@category)-1] || @categories.last
    @prev_category = category.name
  end

  def next_category
    category = @categories[@categories.find_index(@category)+1] || @categories.first
    @next_category = category.name
  end

end