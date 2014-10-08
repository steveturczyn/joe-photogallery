require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    it "should render show template if category is valid" do
      category = Fabricate(:category)
      get :show, id: category.id
      expect(response).to render_template :show
    end
  end
  # describe "POST create" do
  #   # before { set_current_user }
  #   it "should redirect to the New Category page" do
  #     @user = Fabricate(:user)
  #     sign_in @user
  #     category = Fabricate(:category)
  #     post :create, category: { name: category.name, user_id: session[:user_id] }
  #     expect(response).to redirect_to new_category_path
  #   end
  # end
end