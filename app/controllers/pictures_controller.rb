class PicturesController < ApplicationController

  before_action :authenticate_user!, except: [:show]

  def new
    if current_user.categories.empty?
      flash[:error] = "You must create a category before you can add, edit, or delete photos."
      redirect_to new_user_category_path(current_user)
    else
      get_sorted_pictures
      @categories = current_user.categories
      @picture = Picture.new
    end
  end

  def create
    get_sorted_pictures
    @categories = current_user.categories
    @picture = Picture.new(picture_params)
    if @picture.save
      flash[:success] = "You have successfully added your new photo \"#{@picture.title}.\""
      redirect_to new_user_picture_path
    else
      flash.now[:error] = @picture.errors[:represent_category].first
      flash.now[:error] ||= @picture.errors[:represent_user].first
      flash.now[:error] ||= "Please fix the #{view_context.pluralize(@picture.errors.count, "error")} below:"
      render :new
    end
  end

  def edit
    get_sorted_pictures
    @picture = Picture.find(params[:id])
    @categories = Category.select{|category| category.user_id == current_user.id }
  end

  def update
    @picture = Picture.find(params[:id])
    if params[:picture][:category_id].to_i != @picture.category.id && @picture.represent_category
      flash.now[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents the \"#{@picture.category.name}\" category. To move \"#{params[:picture][:title]}\" to a new category, please select a new photo to represent the \"#{@picture.category.name}\" category. Once you've done that, you can go back and change the \"#{params[:picture][:title]}\" photo to a new category."
      get_sorted_pictures
      @pictures = Picture.select{|picture| picture.category_id == @picture.category_id && picture.id != @picture.id }.sort_by {|p| p.title.upcase }
      render :edit_pictures
    elsif @picture.represent_category && (params[:picture][:represent_category].to_bool == false)
      flash.now[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents the \"#{@picture.category.name}\" category. Please select a new photo to represent the \"#{@picture.category.name}\" category."
      get_sorted_pictures
      @pictures = Picture.select{|picture| picture.category_id == @picture.category_id && picture.id != @picture.id }.sort_by {|p| p.title.upcase }
      render :edit_pictures
    elsif @picture.represent_category && (params[:picture][:represent_user].to_bool == false)
      flash.now[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents your portfolio. Please select a new photo to represent your portfolio."
      get_sorted_pictures
      @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
      @pictures = Picture.select{|picture| (@category_ids.include? picture.category_id) && (picture.id != @picture.id) }.sort_by {|p| p.title.upcase }
      render :edit_pictures
    elsif @picture.update_attributes(picture_params)
      flash[:success] = "You have successfully updated your picture \"#{@picture.title}.\""
      redirect_to user_picture_path
    else
      flash.now[:error] = "Please fix the #{view_context.pluralize(@picture.errors.count, "error")} below:"
      @categories = current_user.categories
      get_sorted_pictures
      render :edit
    end
  end

  def edit_pictures
    if current_user.has_no_pictures?
      flash[:error] = "You don't have any photos to edit."
      redirect_to new_user_picture_path(current_user)
    else
      get_sorted_pictures
      @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
      @pictures = Picture.select{|picture| @category_ids.include? picture.category_id }.sort_by {|p| p.title.upcase }
    end
  end

  def which_picture_to_edit
    if params[:id].blank?
      flash[:error] = "Please select a picture to edit."
      redirect_to edit_pictures_user_pictures_path(current_user)
    else
      redirect_to edit_user_picture_path(current_user, params[:id])
    end
  end

  def show
    get_sorted_pictures
    @picture = Picture.find(params[:id])
    @sorted_pictures_of_category = Picture.select {|picture| picture.category_id == @picture.category_id }.sort_by {|p| p.id }
    @show_user = @picture.user
    @pictures = [@picture]
    @sorted_pictures_of_category.each do |picture|
      next if picture == @picture
      @pictures << picture
    end

    prev_picture
    next_picture
  end

  def delete_pictures
    if current_user.has_no_pictures?
      flash[:error] = "You don't have any photos to delete."
      redirect_to new_user_picture_path(current_user)
    else
      get_sorted_pictures
      @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
      @pictures = Picture.select{|picture| @category_ids.include? picture.category_id }.sort_by {|p| p.title.upcase }
    end
  end

  def which_picture_to_delete
    if params[:id].blank?
      flash[:error] = "Please select a photo to delete."
      redirect_to delete_pictures_user_pictures_path(current_user)
    elsif Picture.find(params[:id]).represent_user
      flash.now[:error] = "Your \"#{Picture.find(params[:id]).title}\" photo is the photo that currently represents your portfolio. To delete \"#{Picture.find(params[:id]).title},\" please select a new photo to represent your portfolio."
      @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
      @pictures = Picture.select{|picture| (@category_ids.include? picture.category_id) && (picture.id != params[:id].to_i) }.sort_by {|p| p.title.upcase }
      render :edit_pictures
    elsif Picture.find(params[:id]).represent_category
      flash.now[:error] = "Your \"#{Picture.find(params[:id]).title}\" photo currently represents the \"#{Picture.find(params[:id]).category.name}\" category. To delete \"#{Picture.find(params[:id]).title},\" please select a new photo to represent the \"#{Picture.find(params[:id]).category.name}\" category."
      @pictures = Picture.select{|picture| picture.category == Picture.find(params[:id]).category && picture.id != params[:id].to_i }.sort_by {|p| p.title.upcase }
      render :edit_pictures
    else
      flash[:success] = "Your photo \"#{Picture.find(params[:id]).title}\" has been deleted."
      Picture.destroy(params[:id])
      redirect_to user_path(current_user)
    end
  end

  private

  def prev_picture
    @prev_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture)-1] || @sorted_pictures_of_category.last
  end

  def next_picture
    @next_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture)+1] || @sorted_pictures_of_category.first
  end

  def picture_params
    params.require(:picture).permit(:title, :location, :description, :image_link, :image_link_cache, :category_id, :represent_category, :represent_user)
  end
end