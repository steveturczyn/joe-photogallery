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
      redirect_to new_user_picture_path
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
    render_categories_page
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
    render_categories_page
  end

  def which_category_to_delete
    if params[:id].blank?
      flash[:error] = "Please select a category to delete."
      redirect_to delete_categories_user_categories_path(current_user)
    else
      if Category.find(params[:id]).name == "Uncategorized"
        render "confirm_category_delete"
        return
      end
      delete_category(Category.find(params[:id]))
      if Category.where(user: current_user).count == 0
        flash[:error] = "Since you have deleted your last category, please add a category."
        redirect_to new_user_category_path
      elsif current_user.has_no_pictures?
        redirect_to root_path
      else
        redirect_to user_path(current_user)
      end
    end
  end

  def delete_category(category)
    if category.pictures.empty? || category.name == "Uncategorized"
      flash[:success] = "Your category has been deleted." if Category.where(user: current_user).count > 1
    else
      replacement_category = Category.where(name: "Uncategorized", user: current_user).first
      replacement_category ||= Category.create(name: "Uncategorized", user: current_user)
      flash[:success] = "Your pictures have been moved to the \"Uncategorized\" category."
      category.pictures.each do |picture|
        picture.category = replacement_category
        picture.save
      end
    end
    if category.name == "Uncategorized"
      category.destroy
    else
      category.delete
    end
  end

  def confirm_category_delete
    if params[:confirm]
      delete_category(Category.where(name: "Uncategorized", user: current_user).first)
      if current_user.categories.count == 0
        flash[:error] = "Since you have deleted your last category, please add a category."
        redirect_to new_user_category_path(current_user)
      else
        redirect_to user_path(current_user)
      end
    else
      flash[:notice] = "Your category has not been deleted."
      redirect_to user_path(current_user)
    end
  end

  private

  def representational_categories
    Picture.select{|picture| @categories.include?(picture.category_id) && picture.represent_category }
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def render_categories_page
    if current_user.categories.empty?
      flash[:error] = "You have no categories. Please add a category."
      redirect_to new_user_category_path(current_user)
    else
      @categories = current_user.categories
    end
  end
end