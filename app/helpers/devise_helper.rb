module DeviseHelper

  def devise_error_messages!
     flash.now[:error] = "Please fix the #{pluralize(resource.errors.full_messages.count, "error")} below:" if resource.errors.full_messages.first.present?
  end
end