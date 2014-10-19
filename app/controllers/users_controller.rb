class UsersController < ApplicationController

  def index
    get_sorted_pictures

    @categories = users_pictures.sort!{|a, b| a.name.downcase <=> b.name.downcase }
    
    @category = Category.find_by(name: params[:cat], user_id: session[:user_id]) || @categories.first

    @picture = Picture.select{|picture| picture.represent_category }.select{|p| @category.id == p.category_id }.first

    prev_category
    next_category
  end

  private

  def representational_pictures
    Picture.select{|picture| picture.represent_category }.map{|p| p.category }
  end

  def users_pictures
    representational_pictures.select{|category| category.user_id == session[:user_id] }
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