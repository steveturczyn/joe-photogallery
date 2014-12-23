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
    if Category.select{|category| category.user_id == resource.id } == []
      new_user_category_path(resource)
    else
      user_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    user_path(User.retrieve_logged_off_user)
  end
end
