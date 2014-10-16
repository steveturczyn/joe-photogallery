class CategoriesController < ApplicationController

  before_filter :get_sorted_pictures
  before_action :authenticate_user!, except: [:index, :show]

  def index
    categories = Category.select{|category| category.user_id == session[:user_id] }.map{|c| c.id }
    @pictures = Picture.select{|picture| categories.include? picture.category_id }.select{|p| p.represent_category }.sort!{|a, b| a.category.name <=> b.category.name }
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    session[:category_id] = params[:id].to_i
  end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    if @category.save
      flash[:success] = "You have successfully added your new category \"#{@category.name}.\""
      redirect_to new_category_path
    else
      flash[:error] = "Please fix the error(s) below."
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end