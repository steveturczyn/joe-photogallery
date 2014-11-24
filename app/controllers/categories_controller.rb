class CategoriesController < ApplicationController

  before_action :get_sorted_pictures
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @show_user = User.find(params[:user_id])
    @categories = @show_user.categories.map{|category| category.id }
    @pictures = representational_categories.sort!{|a, b| a.category.name <=> b.category.name }
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @show_user = @category.user
  end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    if @category.save
      flash[:success] = "You have successfully added your new category \"#{@category.name}.\""
      redirect_to new_user_category_path
    else
      flash.now[:error] = "Please fix the #{view_context.pluralize(@category.errors.count, "error")} below:"
      render :new
    end
  end

  private

  def representational_categories
    Picture.select{|picture| @categories.include?(picture.category_id) && picture.represent_category }
  end

  def category_params
    params.require(:category).permit(:name)
  end
end