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
    if @picture.save
      flash.now[:success] = "You have successfully added your new photo \"#{@picture.title}.\""
      redirect_to new_user_category_path
    else
      flash.now[:error] = @picture.errors[:represent_category].first
      flash.now[:error] ||= @picture.errors[:represent_user].first
      flash.now[:error] ||= "Please fix the #{view_context.pluralize(@picture.errors.count, "error")} below:"
      render :new
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

  def picture_params
    params.require(:picture).permit(:title, :location, :description, :image_link, :represent_category, :represent_user)
  end

end
