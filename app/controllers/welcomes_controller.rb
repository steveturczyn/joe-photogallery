class WelcomesController < ApplicationController

  def index
    @images = Image.all
  end

end
