require 'spec_helper'

describe UsersController do
  describe 'GET index' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true, represent_user: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true, represent_user: true)}

    it "builds a Categories collection" do
      get :show, id: charlie.id
      expect(assigns(:categories).first).to eq(apples)
    end
    it "renders the show template" do
      get :show, id: charlie.id
      expect(response).to render_template :show
    end
    it "selects the correct category when category name and user id are provided as params" do
      get :show, cat: "Bananas", id: charlie.id
      expect(assigns(:category)).to eq(bananas)
    end
    it "selects the first category when category name is not provided as a parameter" do
      get :show, id: charlie.id
      expect(assigns(:category)).to eq(apples)
    end
    it "creates a Picture object from an array of Pictures objects" do
      get :show, cat: "Bananas", id: charlie.id
      expect(assigns(:picture)).to eq(chiquita)
    end
    it "verifies that categories are in alpha order" do
      get :show, cat: "Bananas", id: charlie.id
      expect(assigns(:categories)).to eq [apples, bananas, cherries]
    end
    it "verifies that previous category is selected" do
      get :show, cat: bananas.name, id: charlie.id
      expect(assigns(:prev_category)).to eq(apples.name)
    end
    it "verifies that next category is selected" do
      get :show, cat: bananas.name, id: charlie.id
      expect(assigns(:next_category)).to eq(cherries.name)
    end
  end
end