class PicturesController < ApplicationController

  def new
    get_sorted_pictures
    @picture = Picture.new
    session[:category_id] = params[:category]
  end

  def create
    get_sorted_pictures
    @picture = Picture.new(picture_params)
    @picture.category_id = session[:category_id]
    set_represent_user_and_represent_category_values
    if flash[:error].nil?
      if @picture.save
        flash[:success] = "You have successfully added your new photo \"#{@picture.title}.\""
        redirect_to new_user_category_path
      else
        flash[:error] = "Please fix the #{help.pluralize(@picture.errors.count, "error")} below:"
        render :new
      end
    end
  end

  def show
    get_sorted_pictures
    @picture = Picture.find(params[:id])
    @sorted_pictures_of_category = Picture.select {|picture| picture.category_id == @picture.category_id }.sort_by {|p| p.id }
    @show_user = @picture.user

    prev_picture
    next_picture
  end

  private

  def prev_picture
    @prev_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture)-1] || @sorted_pictures_of_category.last
  end

  def next_picture
    @next_picture = @sorted_pictures_of_category[@sorted_pictures_of_category.find_index(@picture)+1] || @sorted_pictures_of_category.first
  end

  def set_represent_user_and_represent_category_values
    if params[:picture][:represent_user] == "true"
      if params[:picture][:represent_category] == "false"
        flash[:error] = "Since your picture represents this user, it must also represent this category. Please change the \"Represents this Category?\" field to \"YES\"."
        render :new
        return
      else
        current_user_id = current_user.id
        Picture.set_represent_user_to_false(current_user_id)
      end
    end
    Picture.set_represent_category_to_false(session[:category_id]) if params[:picture][:represent_category] == "true"
  end

  def picture_params
    params.require(:picture).permit(:title, :location, :description, :image_link, :represent_category, :represent_user)
  end

end
