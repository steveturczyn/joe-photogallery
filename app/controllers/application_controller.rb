class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_sorted_pictures
    @sorted_pictures = Picture.user_representations
  end

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    registration_params = [:email, :password, :password_confirmation, :first_name, :last_name, :bio]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password, :first_name, :last_name, :bio)
      }
    end
  end

  def after_sign_in_path_for(resource)
    if resource.categories.blank?
      new_user_category_path(resource)
    elsif resource.has_no_pictures?
      new_user_picture_path(resource)
    else
      user_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    user = User.find_by_id(User.retrieve_logged_off_user)
    if user && user.categories.present? && user.has_pictures?
      user_path(user)
    else
      root_path
    end
  end

  def other_pictures_in_category
    @picture.represents_category.pictures.reject{ |p| p == @picture }
  end

  def extract_represents_category(represent_string)
    name = represent_string.split(" ")[0]
    if name != "None"
      represents_category = Category.find_by(name: name, user_id: current_user.id)
    else
      represents_category = nil
    end
    represents_category
  end

  def set_represents_category(represent_string, picture)
    picture.represents_category = extract_represents_category(represent_string)
    picture.save

  end
end
