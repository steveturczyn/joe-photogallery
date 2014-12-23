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

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "You have successfully updated your category. The category is now \"#{@category.name}.\""
      redirect_to user_category_path
    else
      flash.now[:error] = "Please fix the #{view_context.pluralize(@category.errors.count, "error")} below:"
      render :new
    end
  end

  def edit_categories
    @categories = current_user.categories
  end

  def which_category_to_edit
    if params[:id].blank?
      flash[:error] = "Please select a category to edit."
      redirect_to edit_categories_user_categories_path(current_user)
    else
      redirect_to edit_user_category_path(current_user, params[:id])
    end
  end

  def delete_categories
    @categories = current_user.categories
  end

  def which_category_to_delete
    if params[:id] == nil
      flash[:error] = "Please select a category to delete."
      redirect_to delete_categories_user_categories_path(current_user)
    else
      delete_category Category.find(params[:id])
      redirect_to user_path(current_user)
    end
  end

  def delete_category(category)
    if category.pictures.empty?
      flash[:success] = "Your category has been deleted."
    else
      replacement_category = Category.where(name: "Uncategorized", user: current_user).first
      replacement_category ||= Category.create(name: "Uncategorized", user: current_user)
      flash[:success] = "Your pictures have been moved to the \"Uncategorized\" category."
      category.pictures.each do |picture|
        picture.category = replacement_category
        picture.save
      end
    end
    category.delete
  end

  private

  def representational_categories
    Picture.select{|picture| @categories.include?(picture.category_id) && picture.represent_category }
  end

  def category_params
    params.require(:category).permit(:name)
  end
end