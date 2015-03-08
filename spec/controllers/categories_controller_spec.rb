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
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true, represent_user: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true, represent_user: true)}
    it "creates an array of Category id's" do
      get :index, user_id: charlie.id
      expect(assigns(:categories)).to eq([apples, bananas, cherries])
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
      it_behaves_like "require sign in" do
        let(:action) { get :new, user_id: user.id }
      end
      it "creates a new Category object" do
        get :new, user_id: user.id
        expect(assigns(:category)).to be_new_record
        expect(assigns(:category)).to be_instance_of(Category)
      end
      it "should render the Add a Category page" do
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
      it_behaves_like "require sign in" do
        let(:action) { post :create, user_id: user.id, category: { name: "Apples" } }
      end
      it "should redirect to the Add a Picture page" do
        post :create, user_id: user.id, category: { name: "Bananas" }
        expect(response).to redirect_to new_user_picture_path(user)
      end
    end
    describe "POST #which_category_to_edit" do
      it_behaves_like "require sign in" do
        let(:action) { post :which_category_to_edit, user_id: user.id, id: "" }
      end
      it "should produce a flash error when submitted without selecting a category" do
        post :which_category_to_edit, user_id: user.id, id: ""
        expect(flash[:error]).to eq("Please select a category to edit.")
        expect(response).to redirect_to edit_categories_user_categories_path(user)
      end
      it "should redirect to the Edit a Category page when user has selected a category" do
        category = Fabricate(:category)
        post :which_category_to_edit, user_id: user.id, id: category.id
        expect(response).to redirect_to edit_user_category_path(user, category)
      end
    end
    describe "PUT update" do
      let(:category) {Fabricate(:category)}
      it_behaves_like "require sign in" do
        let(:action) { put :update, user_id: user.id, category: category, category: { name: "villages" }, id: category.id }
      end
      it "should produce a flash error when submitting form with a blank category" do
        put :update, user_id: user.id, category: category, category: { name: "" }, id: category.id
        expect(flash[:error]).to eq("Please fix the 1 error below:")
        expect(response).to render_template :new
      end
      it "should produce a flash success message" do
        put :update, user_id: user.id, category: category, category: { name: "villages" }, id: category.id
        expect(flash[:success]).to eq("You have successfully updated your category. The category is now \"villages.\"")
      end
      it "should update the category name in the database" do
        put :update, user_id: user.id, category: category, category: { name: "villages" }, id: category.id
        expect(category.reload.name).to eq("villages")
      end
      it "should redirect to the Show Category page" do
        put :update, user_id: user.id, category: category, category: { name: "category.name" }, id: category.id
        expect(response).to redirect_to user_category_path(user, category)
      end
    end
    describe "POST #which_category_to_delete" do
      it_behaves_like "require sign in" do
        let(:category) {Fabricate(:category)}
        let(:action) { post :which_category_to_delete, user_id: user.id, id: category.id }
      end
      it "should produce a flash error when submitted without selecting a category" do
        post :which_category_to_delete, user_id: user.id, id: ""
        expect(flash[:error]).to eq("Please select a category to delete.")
        expect(response).to redirect_to delete_categories_user_categories_path(user)
      end
      it "should render the Confirm Category Deletion page when user has requested to delete an 'Uncategorized' category" do
        category = Fabricate(:category, user: user, name: "Uncategorized")
        post :which_category_to_delete, user_id: user.id, id: category.id
        expect(response).to render_template "confirm_category_delete"
      end
      it "should delete the requested category" do
        category = Fabricate(:category, user: user, name: "Wildlife")
        post :which_category_to_delete, user_id: user.id, id: category.id
        expect(Category.where(name: "Wildlife")).to be_empty
      end
      it "should produce a flash error when last category has been deleted" do
        category = Fabricate(:category, user: user)
        post :which_category_to_delete, user_id: user.id, id: category.id
        expect(flash[:error]).to eq("Since you have deleted your last category, please add a category.")
        expect(response).to redirect_to new_user_category_path(user)
      end
      it "should redirect to the Home page if there are no pictures" do
        category1 = Fabricate(:category, user: user)
        category2 = Fabricate(:category, user: user)
        post :which_category_to_delete, user_id: user.id, id: category1.id
        expect(response).to redirect_to root_path
      end
      it "should redirect to the User Show page if there are one or more pictures" do
        category1 = Fabricate(:category, user: user)
        category2 = Fabricate(:category, user: user)
        photo = Fabricate(:picture, title: "Bing", category: category2, category_id: category2.id, represent_category: true, represent_user: true)
        post :which_category_to_delete, user_id: user.id, id: category1.id
        expect(response).to redirect_to user_path(user)
      end
    end
    describe "GET delete_categories" do
      it_behaves_like "require sign in" do
        let(:action) { get :delete_categories, user_id: user.id }
      end
      it "should create a flash message if there are no categories to delete" do
        get :delete_categories, user_id: user.id
        expect(flash[:error]).to eq("You have no categories. Please add a category.")
        expect(response).to redirect_to new_user_category_path(user)
      end
      it "should create an array of category objects" do
        category1 = Fabricate(:category, user: user)
        category2 = Fabricate(:category, user: user)
        get :delete_categories, user_id: user.id
        expect(assigns(:categories)).to include(category1, category2)
      end
    end
    describe "POST confirm_category_delete" do
      it_behaves_like "require sign in" do
        let(:action) { post :confirm_category_delete, user_id: user.id, confirm: true }
      end
      it "should delete the category" do
        category = Fabricate(:category, user: user, name: "Uncategorized")
        expect(Category.count).to eq(1)
        post :confirm_category_delete, user_id: user.id, confirm: true
        expect(Category.count).to eq(0)
      end
    end
  end
end