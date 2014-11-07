require 'spec_helper'

describe CategoriesController do
  describe "GET index" do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:barry) {Fabricate(:user, first_name: "Barry", last_name: "Bonds", id: 2)}
    let!(:angela) {Fabricate(:user, first_name: "Angela", last_name: "Atkins", id: 3)}

    let!(:dogs) {Fabricate(:category, name: "Dogs", user: barry)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}
    it "creates an array of Category id's" do
      get :index, user_id: charlie.id
      expect(assigns(:categories)).to eq([cherries.id, bananas.id, apples.id])
    end
    it "creates a sorted array of Picture objects" do
      get :index, user_id: charlie.id
      expect(assigns(:pictures)).to eq([mcintosh, chiquita, bing])
    end
  end
  describe "tests where user is already signed in" do
    let(:user) {Fabricate(:user)}
    before do
      sign_in user
    end
    describe "GET new" do
      it "creates a new Category object" do
        get :new, user_id: user.id
        expect(assigns(:category)).to be_new_record
        expect(assigns(:category)).to be_instance_of(Category)
      end
      it "should render the Add a Photo or Category page" do
        get :new, user_id: user.id
        expect(response).to render_template :new
      end
    end
    describe "GET show" do
      it "should render show template if category is valid" do
        category = Fabricate(:category)
        get :show, user_id: user.id, id: category.id
        expect(response).to render_template :show
      end
    end
    describe "POST create" do
      it "should redirect to the New Category page" do
        category = Fabricate(:category)
        post :create, user_id: user.id, category: { name: category.name }
        expect(response).to redirect_to new_user_category_path
      end
    end
  end
end