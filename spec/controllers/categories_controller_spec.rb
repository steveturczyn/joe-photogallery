require 'spec_helper'

describe CategoriesController do
  describe 'GET new' do
    it "creates a new Category object" do
      set_current_user
      @user = Fabricate(:user)
      sign_in @user
      get :new
      expect(assigns(:category)).to be_new_record
      expect(assigns(:category)).to be_instance_of(Category)
    end
    it "should render the Add Photo page" do
      set_current_user
      @user = Fabricate(:user)
      sign_in @user
      get :new
      expect(response).to render_template :new
    end
  end
  describe "GET show" do
    it "should render show template if category is valid" do
      category = Fabricate(:category)
      get :show, id: category.id
      expect(response).to render_template :show
    end
  end
  describe "POST create" do
    it "should redirect to the New Category page" do
      set_current_user
      @user = Fabricate(:user)
      sign_in @user
      category = Fabricate(:category)
      post :create, category: { name: category.name, user_id: session[:user_id] }
      expect(response).to redirect_to new_category_path
    end
  end
end