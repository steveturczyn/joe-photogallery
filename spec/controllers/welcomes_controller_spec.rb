require 'spec_helper'

describe WelcomesController do
  describe 'GET index' do
    it "builds a Categories collection" do
      apples = Fabricate(:category, name: "Apples")
      bananas = Fabricate(:category, name: "Bananas")
      cherries = Fabricate(:category, name: "Cherries")
      get :index
      expect(assigns(:categories).first).to eq apples
    end
    it "renders the index template" do
      apples = Fabricate(:category, name: "Apples")
      bananas = Fabricate(:category, name: "Bananas")
      cherries = Fabricate(:category, name: "Cherries")
      get :index
      expect(response).to render_template :index
    end
    it "verifies that categories are in alpha order" do
      apples = Fabricate(:category, name: "Apples")
      bananas = Fabricate(:category, name: "Bananas")
      cherries = Fabricate(:category, name: "Cherries")
      get :index
      expect(assigns(:categories)).to eq [apples, bananas, cherries]
    end
    # it "verifies that previous category is selected" do
    #   apples = Fabricate(:category, name: "Apples")
    #   bananas = Fabricate(:category, name: "Bananas")
    #   cherries = Fabricate(:category, name: "Cherries")
    #   category = bananas
    #   get :index
    #   expect(assigns(:categories[:categories.find_index(:category)-1])).to eq apples
    # end
  end
end