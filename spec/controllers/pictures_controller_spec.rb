require 'spec_helper'

describe PicturesController do
  describe 'GET new' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    before do
      sign_in charlie
    end
    it "creates a new Picture object" do
      get :new, user_id: charlie.id
      expect(assigns(:picture)).to be_new_record
      expect(assigns(:picture)).to be_instance_of(Picture)
    end
    it "should render the Add a Photo page" do
      get :new, user_id: charlie.id
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context "bad input" do
      let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

      let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}

      let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)}
      let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)}
      before do
        sign_in charlie
      end
      it "should render the new template" do
        post :create, user_id: charlie.id, picture: { category_id: cherries.id, location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: bing.represent_category, represent_user: bing.represent_user }
        expect(response).to render_template :new
      end
      it "should return a flash error message" do
        post :create, user_id: charlie.id, picture: { category_id: cherries.id, location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: bing.represent_category, represent_user: bing.represent_user }
        expect(flash[:error]).to eq("Please fix the 1 error below:")
      end
    end

    context "first picture" do
      let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
      let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
      before do
        sign_in charlie
      end
      context "bad input" do
        it "should return a flash error message if represent_category is false" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: false, represent_user: false }
          expect(flash[:error]).to eq("This picture must represent the category.")
        end
        it "should return a flash error message if represent_user is false" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: true, represent_user: false }
          expect(flash[:error]).to eq("Your first picture must represent the user.")
        end
      end
      context "good input" do
        it "should add the picture to the database if represent_category and represent_user are both true" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: true, represent_user: true }
          updated_bing = Picture.select {|picture| picture.title == "Bing" }.first
          expect(updated_bing.title).to eq("Bing")
        end
        it "should add the picture to the database when it's the second picture of a given category and the picture does not represent the category" do
          bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: false, represent_user: false }
          updated_darkhudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(updated_darkhudson.title).to eq("Dark Hudson")
        end
        it "should set represent_category boolean of existing picture to false when adding a new picture that represents the category" do
          bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: true, represent_user: true }
          expect(bing.reload.represent_category).to eq(false)
          updated_darkhudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(updated_darkhudson.title).to eq("Dark Hudson")
        end
      end
    end

    context "represent_category and represent_user tests" do
      let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
      let!(:cherries) {cherries = Fabricate(:category, name: "Cherries", user: charlie)}
      let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)}
      before do
        sign_in charlie
      end
      context "represent_user is true and represent_category is true" do
        it "should alter represent_user and represent_category fields in existing record in database and add new record to database" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "true", represent_user: "true" }
          expect(bing.reload.represent_category).to be_falsey
          expect(bing.reload.represent_user).to be_falsey
          dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(dark_hudson.title).to eq("Dark Hudson")
        end
      end
      context "represent_user is true and represent_category is false" do
        it "should produce a flash error message" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "false", represent_user: "true" }
          expect(flash[:error]).to eq("Since your picture represents this user, it must also represent this category.")
          bing = Picture.select {|picture| picture.title == "Bing" }.first
          expect(bing.represent_category).to be_truthy
          expect(bing.represent_user).to be_truthy
        end
      end
      context "represent_user is false and represent_category is true" do
        it "should display a flash error message" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "true", represent_user: "false" }
          expect(flash[:error]).to eq("A picture must represent a user.")
          
        end
      end
      context "represent_user is false and represent_category is false" do
        it "should leave existing record in database unchanged and add new record to database" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "false", represent_user: "false" }
          bing = Picture.select {|picture| picture.title == "Bing" }.first
          expect(bing.represent_category).to be_truthy
          expect(bing.represent_user).to be_truthy
          dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(dark_hudson.title).to eq("Dark Hudson")
        end
        it "should redirect to the Add a Photo page" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: false, represent_user: false }
          expect(response).to redirect_to new_user_picture_path
        end
      end
    end  
  end

  describe 'GET show' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true, id: 1)}
    let!(:bright_red_sour) {Fabricate(:picture, title: "Bright Red Sour", category: cherries, category_id: cherries.id, represent_category: false, id: 2)}
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: false, represent_user: false, id: 3)}
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