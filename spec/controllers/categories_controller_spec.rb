require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    it "should render show template if category is valid" do
      category = Fabricate(:category)
      get :show, id: category.id
      expect(response).to render_template :show
    end
  end
end