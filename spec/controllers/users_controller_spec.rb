require 'spec_helper'

describe UsersController do
  describe 'GET index' do
    before { set_current_user }
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}

    it "builds a Categories collection" do
      get :index, first_name: "Charlie", last_name: "Chan"
      expect(assigns(:categories).first).to eq(apples)
    end
    it "renders the index template" do
      get :index, first_name: "Charlie", last_name: "Chan"
      expect(response).to render_template :index
    end
    it "selects the first category when User's first and last names are provided as params" do
      get :index, first_name: "Charlie", last_name: "Chan"
      expect(assigns(:category)).to eq(apples)
    end
    it "selects the correct category when category name and user id are provided as params" do
      get :index, cat: "Bananas", user_id: bananas.id
      expect(assigns(:category)).to eq(bananas)
    end
    it "creates a Picture object from an array of Pictures objects" do
      get :index, cat: "Bananas", user_id: bananas.id
      expect(assigns(:picture)).to eq(chiquita)
    end
    it "verifies that categories are in alpha order" do
      get :index, first_name: "Charlie", last_name: "Chan"
      expect(assigns(:categories)).to eq [apples, bananas, cherries]
    end
    it "verifies that previous category is selected" do
      get :index, cat: bananas.name
      expect(assigns(:prev_category)).to eq(apples.name)
    end
    it "verifies that next category is selected" do
      get :index, cat: bananas.name
      expect(assigns(:next_category)).to eq(cherries.name)
    end
  end
end