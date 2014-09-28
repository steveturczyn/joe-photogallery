class UsersController < ApplicationController

  # before_action :authenticate_user!

  def index
    if params[:id].present?
      determine_categories
      @category = @@categories.first
    else
      @category = Category.find_by(name: params[:cat])
    end

    @pictures = @category.pictures
    @picture = @pictures.find_by_represent_category(true)
    
    @prev_category = prev_category
    @next_category = next_category
  end

  private

  def determine_categories
    pictures = Picture.all
    user = User.find_by(name: params[:id])
    id = user.id
    user_categories = Category.select{|category| category.user_id == id }
    user_categories_array = []
    
    user_categories.each do |category|
      user_categories_array << category.id
    end
    
    good_categories = pictures.map{|picture| picture.category_id}.uniq
    good_user_categories = good_categories & user_categories_array
    all_categories = Category.order(name: :asc)
    @@categories = []

    all_categories.each_with_index do |category, index|  
      @@categories << all_categories[index] if good_user_categories.include?(all_categories[index].id)
    end
  end

  def prev_category
    category = @@categories[@@categories.find_index(@category)-1] || @@categories.last
    category.name
  end

  def next_category
    category = @@categories[@@categories.find_index(@category)+1] || @@categories.first
    category.name
  end

end
