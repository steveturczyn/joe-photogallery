class WelcomesController < ApplicationController

  def index
    @categories = Category.order(name: :asc)
    @category = Category.find_by(name: params[:cat]) || @categories.first
    @image = @category.images.first
    @prev = prev_category
    @next = next_category
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
