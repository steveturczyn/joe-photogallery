class UsersController < ApplicationController

  def index
    determine_categories
    if params[:first_name].present?
      @category = @categories.first
    else
      @category = Category.find_by(name: params[:cat], user_id: session[:user_id])
    end

    @pictures = @category.pictures
    @picture = @pictures.find_by_represent_category(true)
    
    @prev_category = prev_category
    @next_category = next_category
  end

  private

  def determine_categories
    pictures = Picture.all
    if params[:first_name]
      user = User.find_by(first_name: params[:first_name], last_name: params[:last_name])
    else
      user = User.find(session[:user_id])
    end
    id = user.id
    user_categories = Category.select{|category| category.user_id == id }
    user_categories_array = []
    
    user_categories.each do |category|
      user_categories_array << category.id
    end
    
    good_categories = pictures.map{|picture| picture.category_id}.uniq
    good_user_categories = good_categories & user_categories_array
    all_categories = Category.order(name: :asc)
    @categories = []

    all_categories.each_with_index do |category, index|  
      @categories << all_categories[index] if good_user_categories.include?(all_categories[index].id)
    end
  end

  def prev_category
    category = @categories[@categories.find_index(@category)-1] || @categories.last
    category.name
  end

  def next_category
    category = @categories[@categories.find_index(@category)+1] || @categories.first
    category.name
  end

end
