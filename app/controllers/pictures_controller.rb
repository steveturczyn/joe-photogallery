class PicturesController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :get_sorted_pictures, except: [:which_picture_to_edit, :which_picture_to_delete, :select_cat_picture]

  def new
    if current_user.categories.empty?
      flash[:error] = "You must create a category before you can add, edit, or delete photos."
      redirect_to new_user_category_path(current_user)
    else
      @categories = current_user.categories
      @picture = Picture.new
    end
  end

  def create
    @categories = current_user.categories
    @picture = Picture.new(picture_params)
    @picture.categories = [Category.find(picture_params[:category_id])] if picture_params[:category_id].present?
    @picture.set_user_picture = picture_params[:set_user_picture].to_s.downcase == "true" ? true : false
    @picture.set_cat_picture = picture_params[:set_cat_picture].to_s.downcase == "true" ? true : false
    @picture.represents_category = nil
    @picture.represents_user = nil
    @picture.represents_category = @picture.category if @picture.category && @picture.set_cat_picture
    @picture.represents_user = @picture.user if @picture.category && @picture.set_user_picture
    if @picture.save
      flash[:success] = "You have successfully added your new photo \"#{@picture.title}.\""
      redirect_to new_user_picture_path
    else
      flash.now[:error] = @picture.errors[:represents_category].first
      flash.now[:error] ||= @picture.errors[:represents_user].first
      flash.now[:error] ||= "Please fix the #{view_context.pluralize(@picture.errors.count, "error")} below:"
      render :new
    end
  end

  def edit
    @picture = Picture.find(params[:id])
    @categories = Category.select{|category| category.user_id == current_user.id }.sort_by{ |c| c.name }
    @categories_containing_photo = CategoriesPicture.where(picture_id: @picture.id).map{ |category| category.category_id }
    @radiobutton_category_names = Category.select{|category| category.user_id == current_user.id }.sort_by{ |c| c.name }.map{|c| c.name}.unshift("None")
    name = @picture.category.name
    updated_radiobutton_category_names = []
    @radiobutton_category_names.each do |categoryname|
      if categoryname == name
        updated_radiobutton_category_names << ["#{categoryname}", true]
      else
        updated_radiobutton_category_names << ["#{categoryname}", false]
      end
    end
    @radiobutton_category_names = updated_radiobutton_category_names
  end

  def update
    @picture = Picture.find(params[:id])
    if moving_picture_that_represents_category?
      binding.pry
      SavedRecord.create(record_json: params[:picture], picture_id: @picture.id, user_id: current_user.id)
      flash[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents the \"#{@picture.category.name}\" category. To move \"#{params[:picture][:title]}\" to a new category, please select a new photo to represent the \"#{@picture.category.name}\" category."
      redirect_to select_cat_picture_user_cat_pictures_path(current_user)
      return
    elsif picture_losing_category_status?
      flash.now[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents the \"#{@picture.category.name}\" category. Please select a new photo to represent the \"#{@picture.category.name}\" category."
      @pictures = other_pictures_in_category
      render :edit_pictures
    elsif picture_losing_user_status?
      flash.now[:error] = "Your \"#{params[:picture][:title]}\" photo currently represents your portfolio. Please select a new photo to represent your portfolio."
      @pictures = other_pictures_for_user
      render :edit_pictures
    elsif picture_has_no_category?
      flash.now[:error] = "Please select a category."
      @categories = current_user.categories
      render :edit
    elsif picture_update_attributes?
      flash[:success] = "You have successfully updated your picture \"#{@picture.title}.\""
      redirect_to user_picture_path
    else
      flash.now[:error] = "Please fix the #{view_context.pluralize(@picture.errors.count, "error")} below:"
      @categories = current_user.categories
      render :edit
    end
  end

  def edit_pictures
    if current_user.has_no_pictures?
      flash[:error] = "You don't have any photos to edit."
      redirect_to new_user_picture_path(current_user)
    else
      @pictures = current_user.pictures.uniq.sort_by {|p| p.title.upcase }
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
      @pictures = current_user.pictures.uniq.sort_by {|p| p.title.upcase }
    end
  end

  def which_picture_to_delete
    if params[:id].blank?
      flash[:error] = "Please select a photo to delete."
      redirect_to delete_pictures_user_pictures_path(current_user)
    else
      @picture = Picture.find(params[:id])
      if @picture.represents_user
        flash.now[:error] = "Your \"#{Picture.find(params[:id]).title}\" photo is the photo that currently represents your portfolio. To delete \"#{Picture.find(params[:id]).title},\" please select a new photo to represent your portfolio."
        @pictures = other_pictures_for_user
        render :edit_pictures
      elsif @picture.represents_category
        flash.now[:error] = "Your \"#{Picture.find(params[:id]).title}\" photo currently represents the \"#{Picture.find(params[:id]).category.name}\" category. To delete \"#{Picture.find(params[:id]).title},\" please select a new photo to represent the \"#{Picture.find(params[:id]).category.name}\" category."
        @pictures = other_pictures_in_category
        render :edit_pictures
      else
        flash[:success] = "Your photo \"#{Picture.find(params[:id]).title}\" has been deleted."
        @picture.destroy
        redirect_to user_path(current_user)
      end
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
    params.require(:picture).permit(:title, :location, :description, :image_link, :image_link_cache, :set_cat_picture, :set_user_picture, category_id: [])
  end

  def moving_picture_that_represents_category?
    category_and_represents_category = params[:picture][:set_cat_picture].split(" ")
    category = category_and_represents_category[0]
    @picture.represents_category && (category != @picture.represents_category.name) && @picture.represents_category.pictures.count > 1
  end

  def picture_losing_category_status?
    category_ids = params[:picture][:category_id].select{|id| id != ""}.map(&:to_i)
    category_and_represents_category = params[:picture][:set_cat_picture].split(" ")
    category = category_and_represents_category[0]
    represents_category = category_and_represents_category[1].to_bool
    return false if represents_category
    category_in_db = Category.find_by(picture_id: @picture.id)
    name_in_db = category_in_db.name
    (category_in_db.name != category) || category == "None" ? true : false
  end

  def picture_losing_user_status?
    @picture.represents_user && (params[:picture][:set_user_picture].to_bool == false)
  end

  def other_pictures_for_user
    current_user.pictures.reject{|p| p == @picture }
  end

  def picture_has_no_category?
    params[:picture][:category_id] == [""] ? true : false
  end

  def picture_update_attributes?
    temp_picture_id = @picture.user.picture_id
    @picture.assign_attributes(picture_params)
    @picture.categories = picture_params[:category_id].select{|category_id| category_id.present?}.map{|category_id| Category.find(category_id)} if picture_params[:category_id].present?
    @picture.set_user_picture = picture_params[:set_user_picture].to_s.downcase == "true"
    @picture.represents_user = nil if !@picture.set_user_picture
    @picture.represents_user = @picture.category.user if @picture.category && @picture.set_user_picture
    name = params[:picture][:set_cat_picture].split(" ")
    name = name[0]
    if name != "None"
      id = Category.where(id: params[:picture][:category_id], name: name).map{|category| category.id}.first
      category = Category.find(id)
      @picture.represents_category = category
    else
      @picture.represents_category = nil
    end
    @picture.user.picture_id = temp_picture_id if !@picture.set_user_picture
    @picture.save
  end
end