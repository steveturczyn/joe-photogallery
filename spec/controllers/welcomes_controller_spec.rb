require 'spec_helper'

describe WelcomesController do
  describe 'GET index' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan")}
    let!(:barry) {Fabricate(:user, first_name: "Barry", last_name: "Bonds")}
    let!(:angela) {Fabricate(:user, first_name: "Angela", last_name: "Atkins")}

    let!(:fruits1) {Fabricate(:category, name: "Fruits1", user: angela)}
    let!(:fruits2) {Fabricate(:category, name: "Fruits2", user: barry)}
    let!(:wildlife) {Fabricate(:category, name: "Wildlife", user: charlie)}
    
    let!(:apple) {Fabricate(:picture, title: "Apple", categories: [fruits1], represents_category: fruits1, represents_user: fruits1.user)}
    let!(:banana) {Fabricate(:picture, title: "Banana", categories: [fruits2], represents_category: fruits2, represents_user: fruits2.user)}
    let!(:cheetah) {Fabricate(:picture, title: "Cheetah", categories: [wildlife], represents_category: wildlife, represents_user: wildlife.user)}
    it "verifies that Picture objects have been sorted by last name" do
      get :index
      expect(assigns(:sorted_pictures).first).to eq(apple)
    end
    it "retrieves random Picture object when no ID is present in params" do
      get :index
      picture_list = [apple, banana, cheetah]
      expect(picture_list).to include(assigns(:picture))
    end
    it "retrieves Picture object requested by params" do
      get :index, id: cheetah.id
      expect(assigns(:picture)).to eq(cheetah)
    end
    it "retrieves the second (previous) Picture object when we started with the third Picture object" do
      get :index, id: cheetah.id
      expect(assigns(:prev_picture)).to eq(banana)
    end
    it "retrieves the third (previous) Picture object when we started with the first Picture object" do
      get :index, id: apple.id
      expect(assigns(:prev_picture)).to eq(cheetah)
    end
    it "retrieves the second (next) Picture object when we started with the first Picture object" do
      get :index, id: apple.id
      expect(assigns(:next_picture)).to eq(banana)
    end
    it "retrieves the first (next) Picture object when we started with the third Picture object" do
      get :index, id: cheetah.id
      expect(assigns(:next_picture)).to eq(apple)
    end
    it "retrieves the second (previous) photographer's name when we started with the third photographer's name" do
      get :index, id: cheetah.id
      expect(assigns(:prev_photographer)).to eq("Barry Bonds")
    end
    it "retrieves the third (previous) photographer's name when we started with the first photographer's name" do
      get :index, id: apple.id
      expect(assigns(:prev_photographer)).to eq("Charlie Chan")
    end
    it "retrieves the second (next) photographer's name when we started with the first photographer's name" do
      get :index, id: apple.id
      expect(assigns(:next_photographer)).to eq("Barry Bonds")
    end
    it "retrieves the first (next) photographer's name when we started with the third photographer's name" do
      get :index, id: cheetah.id
      expect(assigns(:next_photographer)).to eq("Angela Atkins")
    end
  end
end