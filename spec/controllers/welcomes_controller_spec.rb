require 'spec_helper'

describe WelcomesController do
  describe 'GET index' do
    let!(:apples) {Fabricate(:category, name: "Apples")}
    let!(:bananas) {Fabricate(:category, name: "Bananas")}
    let!(:cherries) {Fabricate(:category, name: "Cherries")}
    it "builds a Categories collection" do
      get :index
      expect(assigns(:categories).first).to eq apples
    end
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
    it "verifies that categories are in alpha order" do
      get :index
      expect(assigns(:categories)).to eq [apples, bananas, cherries]
    end
    it "verifies that previous category is selected" do
      get :index, cat: bananas.name
      expect(assigns(:prev)).to eq apples.name
    end
    it "verifies that next category is selected" do
      get :index, cat: bananas.name
      expect(assigns(:next)).to eq cherries.name
    end
  end
end