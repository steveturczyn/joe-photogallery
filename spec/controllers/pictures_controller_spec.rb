require 'spec_helper'

describe PicturesController do
  describe 'GET new' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

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

      it "should render the new template" do
        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: bing.represent_category, represent_user: bing.represent_user }
        expect(response).to render_template :new
      end
      it "should return a flash error message" do
        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: bing.represent_category, represent_user: bing.represent_user }
        expect(flash[:error]).to eq("Please fix the 1 error below:")
      end
    end

    context "represent_user is true and represent_category is true" do
      it "should alter represent_user and represent_category fields in existing record in database and add new record to database" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
  
        charlie = Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)

        cherries = Fabricate(:category, name: "Cherries", user: charlie)

        bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
  
        sign_in charlie

        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "true", represent_user: "true" }
        updated_bing = Picture.select {|picture| picture.title == "Bing" }.first
        expect(updated_bing.represent_category).to be_falsey
        expect(updated_bing.represent_user).to be_falsey
        dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
        expect(dark_hudson.title).to eq("Dark Hudson")
      end
    end

    context "represent_user is true and represent_category is false" do
      it "should produce a flash error message" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
  
        charlie = Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)

        cherries = Fabricate(:category, name: "Cherries", user: charlie)

        bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
  
        sign_in charlie

        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "false", represent_user: "true" }
        expect(flash[:error]).to be_present
        bing = Picture.select {|picture| picture.title == "Bing" }.first
        expect(bing.represent_category).to be_truthy
        expect(bing.represent_user).to be_truthy
      end
    end

    context "represent_user is false and represent_category is true" do
      it "should display a flash error message" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
  
        charlie = Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)

        cherries = Fabricate(:category, name: "Cherries", user: charlie)

        bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
  
        sign_in charlie

        session[:category_id] = cherries.id
        binding.pry
        post :create, user_id: charlie.id, picture: { title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "true", represent_user: "false" }
        expect(flash[:error]).to eq("A picture must represent a user.")
      end
    end

    context "represent_user is false and represent_category is false" do
      it "should leave existing record in database unchanged and add new record to database" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
  
        charlie = Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)

        cherries = Fabricate(:category, name: "Cherries", user: charlie)

        bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represent_category: true, represent_user: true)
  
        sign_in charlie

        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: "false", represent_user: "false" }
        bing = Picture.select {|picture| picture.title == "Bing" }.first
        expect(bing.represent_category).to be_truthy
        expect(bing.represent_user).to be_truthy
        dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
        expect(dark_hudson.title).to eq("Dark Hudson")
      end
      it "should redirect to the Add a Photo or Category page" do
        charlie = Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)

        cherries = Fabricate(:category, name: "Cherries", user: charlie)

        session[:category_id] = cherries.id
        post :create, user_id: charlie.id, picture: { title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), represent_category: false, represent_user: false }
        expect(response).to redirect_to new_user_category_path
      end
    end    
  end

  describe 'GET show' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represent_category: true, id: 1)}
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