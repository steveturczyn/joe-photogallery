class UsersController < ApplicationController

  before_action :get_sorted_pictures

  def show

    @show_user = User.find(params[:id])

    @categories = @show_user.categories.sort!{|a, b| a.name.downcase <=> b.name.downcase }
    
    @category = Category.find_by(name: params[:cat], user_id: params[:id]) || @categories.first

    @pictures = @categories.map{ |category| category.representative_picture }.compact.sort_by{ |p| p.title }

    prev_category
    next_category
  end

  private

  def prev_category
    category = @categories[@categories.find_index(@category)-1] || @categories.last
    @prev_category = category.name
  end

  def next_category
    category = @categories[@categories.find_index(@category)+1] || @categories.first
    @next_category = category.name
  end

end