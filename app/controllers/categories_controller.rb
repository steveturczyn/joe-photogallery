class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
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