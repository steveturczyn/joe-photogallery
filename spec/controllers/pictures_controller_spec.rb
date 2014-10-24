require 'spec_helper'

describe PicturesController do
  describe 'GET show' do
    before { set_current_user }
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represent_category: true, id: 1)}
    let!(:bright_red_sour) {Fabricate(:picture, title: "Bright Red Sour", category: cherries, category_id: cherries.id, represent_category: false, id: 2)}
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: false, represent_user: true, id: 3)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represent_category: true)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true)}

    it "builds an array of pictures sorted within a category" do
      session[:category_id] = cherries.id
      get :show, id: cherries.id
      expect(assigns(:sorted_pictures_of_category).first).to eq(dark_hudson)
    end
    it "selects a picture object when an id is present" do
      session[:category_id] = cherries.id
      get :show, id: "2"
      expect(assigns(:picture_of_category)).to eq(bright_red_sour)
    end
    it "selects a picture object when no id is present" do
      session[:category_id] = cherries.id
      get :show, id: "1"
      expect(assigns(:picture_of_category)).to eq(dark_hudson)
    end
    it "verifies that previous picture is selected" do
      session[:category_id] = cherries.id
      get :show, id: "2"
      expect(assigns(:prev_picture)).to eq(dark_hudson)
    end
    it "verifies that next picture is selected" do
      session[:category_id] = cherries.id
      get :show, id: "2"
      expect(assigns(:next_picture)).to eq(bing)
    end
  end
end