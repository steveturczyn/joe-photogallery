class CatPicturesController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :get_sorted_pictures, except: [:which_picture_to_edit, :which_picture_to_delete, :select_cat_picture]

  def select_cat_picture
    saved_record = current_user.saved_record
    @picture = Picture.find(saved_record.picture_id)
    @category = @picture.category
    @pictures = other_pictures_in_category
  end

  def assign_cat_picture
    if params[:id].blank?
      flash[:error] = "Please select a picture to represent the category."
      redirect_to select_cat_picture_user_cat_pictures_path
      return
    end
    new_cat_picture = Picture.find(params[:id])
    new_cat_picture.represent_category = true
    new_cat_picture.save
    saved_record = current_user.saved_record
    moved_picture = Picture.find(saved_record.picture_id)
    moved_picture.assign_attributes(saved_record.record_json.permit!)
    saved_record.destroy
    if moved_picture.save
      redirect_to user_picture_path(current_user, moved_picture)
    else
      @picture = moved_picture
      @categories = Category.select{|category| category.user_id == current_user.id }
      render :edit
    end
  end
end