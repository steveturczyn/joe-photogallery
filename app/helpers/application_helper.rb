module ApplicationHelper

  def convert_flash(treatment)
    return "danger" if [:error, :alert].include? treatment
    return "success" if treatment == :notice
    return treatment
  end
end
