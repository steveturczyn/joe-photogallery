class CatPicturesController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :get_sorted_pictures, except: [:which_picture_to_edit, :which_picture_to_delete, :select_cat_picture]

  def select_cat_picture
    get_picture_and_category
    @pictures = other_pictures_in_category
  end

  def assign_cat_picture
    if params[:id].blank?
      flash[:error] = "Please select a picture to represent the category."
      redirect_to select_cat_picture_user_cat_pictures_path
      return
    end
    new_cat_picture = Picture.find(params[:id])
    saved_record = current_user.saved_record
    get_picture_and_category
    set_represents_category(saved_record.record_json[:set_cat_picture], @picture)
    new_cat_picture.represents_category = @category
    new_cat_picture.save
    
    saved_record.record_json[:category_id].select{|id| id != ""}.each do |new_category_id|
      Category.find(new_category_id.to_i).pictures << @picture unless Category.find(new_category_id.to_i).pictures.include?(@picture)
    end
  
    @picture.categories = saved_record.record_json[:category_id].map{|id|Category.find_by(id: id)}.compact
    @picture.save
    @picture.categories.each {|c|x = c.pictures.uniq; c.pictures = []; c.pictures = x; c.save}
    saved_record.destroy
    redirect_to user_picture_path(current_user, @picture)
  end

  private

  def get_picture_and_category
    saved_record = current_user.saved_record
    @picture = Picture.find(saved_record.picture_id)
    @category = @picture.represents_category
  end
end