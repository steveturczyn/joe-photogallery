class PicturesController < ApplicationController

  def new
    get_sorted_pictures
    @categories = current_user.categories
    @picture = Picture.new
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
    if @picture.update_attributes(picture_params)
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
    get_sorted_pictures
    @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
    @pictures = Picture.select{|picture| @category_ids.include? picture.category_id }.sort_by {|p| p.title.upcase }
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
    get_sorted_pictures
    @category_ids = Category.select{|category| category.user_id == current_user.id }.map{|c| c.id }
    @pictures = Picture.select{|picture| @category_ids.include? picture.category_id }.sort_by {|p| p.title.upcase }
  end

  def which_picture_to_delete
    if params[:id] == nil
      flash[:error] = "Please select a picture to delete."
      redirect_to delete_pictures_user_pictures_path(current_user)
    else
      redirect_to delete_picture_user_pictures_path(current_user, params[:id])
    end
  end

  def destroy 
    #   picture = Picture.where(user_id: current_user.id, id: params[:id]).first
    #   picture.destroy if pategory
    #   display a flash message, saying that the picture has been deleted
    #   redirect_to some page
    # end
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
