module ApplicationHelper

  def convert_flash(treatment, message)
    return "danger" if treatment == :error || message == "You need to sign in or sign up before continuing."
    return "success" if treatment == :notice
    return treatment
  end
end
