require 'spec_helper'

describe BiosController do
  describe 'GET index' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan")}
    let!(:barry) {Fabricate(:user, first_name: "Barry", last_name: "Bonds")}
    let!(:angela) {Fabricate(:user, first_name: "Angela", last_name: "Atkins")}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}

    it "retrieves User object requested by params" do
      set_current_user
      get :index, id: charlie.id
      expect(assigns(:user)).to eq(charlie)
    end
  end
end