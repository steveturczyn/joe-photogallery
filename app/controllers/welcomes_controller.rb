class WelcomesController < ApplicationController

  def index
    @image = Image.first
  end

end
