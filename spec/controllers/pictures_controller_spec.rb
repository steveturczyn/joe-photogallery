require 'spec_helper'

describe PicturesController do
  describe 'GET show' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represent_category: true, id: 1)}
    let!(:bright_red_sour) {Fabricate(:picture, title: "Bright Red Sour", category: cherries, category_id: cherries.id, represent_category: false, id: 2)}
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: false, represent_user: true, id: 3)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}

    it "selects the correct picture object" do
      get :show, user_id: charlie.id, id: bright_red_sour.id
      expect(assigns(:picture)).to eq(bright_red_sour)
    end
    it "builds an array of pictures sorted within a category" do
      get :show, user_id: charlie.id, id: bing.id
      expect(assigns(:sorted_pictures_of_category).first).to eq(dark_hudson)
    end
    it "verifies that previous picture is selected" do
      get :show, user_id: charlie.id, id: bright_red_sour.id
      expect(assigns(:prev_picture)).to eq(dark_hudson)
    end
    it "verifies that next picture is selected" do
      get :show, user_id: charlie.id, id: bright_red_sour.id
      expect(assigns(:next_picture)).to eq(bing)
    end
  end
end