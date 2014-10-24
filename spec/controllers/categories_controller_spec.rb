require 'spec_helper'

describe CategoriesController do
  describe "GET index" do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan")}
    let!(:barry) {Fabricate(:user, first_name: "Barry", last_name: "Bonds")}
    let!(:angela) {Fabricate(:user, first_name: "Angela", last_name: "Atkins")}

    let!(:dogs) {Fabricate(:category, name: "Dogs", user: barry)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}
    it "creates an array of Category id's" do
      set_current_user
      get :index
      expect(assigns(:categories)).to eq([cherries.id, bananas.id, apples.id])
    end
    it "creates a sorted array of Picture objects" do
      set_current_user
      get :index
      expect(assigns(:pictures)).to eq([mcintosh, chiquita, bing])
    end
  end
  describe "GET new" do
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
      set_current_user
      @user = Fabricate(:user)
      sign_in @user
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