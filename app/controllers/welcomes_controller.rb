class WelcomesController < ApplicationController

  def index
    remove_categories_without_pictures

    @category = Category.find_by(name: params[:cat]) || @categories.first
    @picture = @category.pictures.find_by_home(true)
    @prev = prev_category
    @next = next_category
  end

  private

  def remove_categories_without_pictures
    pictures = Picture.all
    good_categories = pictures.map{|picture| picture.category_id}.uniq
    all_categories = Category.order(name: :asc)
    @categories = []
    all_categories.each_with_index do |category, index|  
      @categories << all_categories[index] if good_categories.include? all_categories[index].id
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
