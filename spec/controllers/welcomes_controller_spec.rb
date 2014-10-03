require 'spec_helper'

describe WelcomesController do
  describe 'GET index' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:barry) {Fabricate(:user, first_name: "Barry", last_name: "Bonds", id: 2)}
    let!(:angela) {angela = Fabricate(:user, first_name: "Angela", last_name: "Atkins", id: 3)}

    let!(:fruits1) {Fabricate(:category, name: "Fruits1", user: angela)}
    let!(:fruits2) {Fabricate(:category, name: "Fruits2", user: barry)}
    let!(:wildlife) {Fabricate(:category, name: "Wildlife", user: charlie)}
    
    let!(:apple) {Fabricate(:picture, title: "Apple", category: fruits1, id: 1)}
    let!(:banana) {Fabricate(:picture, title: "Banana", category: fruits2, id: 2)}
    let!(:cheetah) {Fabricate(:picture, title: "Cheetah", category: wildlife, id: 3)}
    it "verifies that Picture objects have been sorted by last name" do
      get :index
      expect(assigns(:sorted_pictures).first).to eq([apple, "Atkins", "Angela"])
    end
    it "retrieves first Picture object when no ID is present in params" do
      get :index
      expect(assigns(:picture)).to eq(apple)
    end
    it "retrieves Picture object requested by params" do
      get :index, id: 3
      expect(assigns(:picture)).to eq(cheetah)
    end
    it "retrieves photographer's full name" do
      get :index
      expect(assigns(:photographer)). to eq("Angela Atkins")
    end
    it "retrieves photographer's first name" do
      get :index
      expect(assigns(:photographer_first_name)). to eq("Angela")
    end
    it "retrieves photographer's last name" do
      get :index
      expect(assigns(:photographer_last_name)). to eq("Atkins")
    end
    it "stores user id session variable" do
      get :index
      expect(session[:user_id]). to eq(3)
    end
    it "retrieves first Picture object from sorted_pictures_without_name" do
      get :index
      expect(assigns(:sorted_pictures_without_name).first).to eq(apple)
    end
    it "retrieves the second (previous) Picture object when we started with the third Picture object" do
      get :index, id: 3
      expect(assigns(:prev_picture)).to eq(banana)
    end
    it "retrieves the third (previous) Picture object when we started with the first Picture object" do
      get :index, id: 1
      expect(assigns(:prev_picture)).to eq(cheetah)
    end
    it "retrieves the second (next) Picture object when we started with the first Picture object" do
      get :index, id: 1
      expect(assigns(:next_picture)).to eq(banana)
    end
    it "retrieves the first (next) Picture object when we started with the third Picture object" do
      get :index, id: 3
      expect(assigns(:next_picture)).to eq(apple)
    end
    it "retrieves the second (previous) photographer's name when we started with the third photographer's name" do
      get :index, id: 3
      expect(assigns(:prev_photographer)).to eq("Barry Bonds")
    end
    it "retrieves the third (previous) photographer's name when we started with the first photographer's name" do
      get :index, id: 1
      expect(assigns(:prev_photographer)).to eq("Charlie Chan")
    end
    it "retrieves the second (next) photographer's name when we started with the first photographer's name" do
      get :index, id: 1
      expect(assigns(:next_photographer)).to eq("Barry Bonds")
    end
    it "retrieves the first (next) photographer's name when we started with the third photographer's name" do
      get :index, id: 3
      expect(assigns(:next_photographer)).to eq("Angela Atkins")
    end
  end
end