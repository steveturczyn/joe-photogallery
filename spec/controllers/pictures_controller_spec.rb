require 'spec_helper'

describe PicturesController do
  describe 'GET new' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    
    before do
      sign_in charlie
    end
    it_behaves_like "require sign in" do
      let(:action) { get :new, user_id: charlie.id }
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

      let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)}
      let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)}
      before do
        sign_in charlie
      end
      it_behaves_like "require sign in" do
        let(:action) { post :create, user_id: charlie.id, picture: { category_id: cherries.id, location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: bing.represents_category, set_user_picture: bing.represents_user } }
      end
      it "should render the new template" do
        post :create, user_id: charlie.id, picture: { category_id: cherries.id, location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: bing.represents_category, set_user_picture: bing.represents_user }
        expect(response).to render_template :new
      end
      it "should return a flash error message" do
        post :create, user_id: charlie.id, picture: { category_id: cherries.id, location: bing.location, description: bing.description, image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: bing.represents_category, set_user_picture: bing.represents_user }
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
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: false, set_user_picture: false }
          expect(flash[:error]).to eq("This picture must represent the category.")
        end
        it "should return a flash error message if represents_user is nil" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: true, set_user_picture: false }
          expect(flash[:error]).to eq("Your first picture must represent the user.")
        end
      end
      context "good input" do
        it "should add the picture to the database if represents_category and represents_user are both present" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Bing", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: "true", set_user_picture: "true" }
          updated_bing = Picture.select {|picture| picture.title == "Bing" }.first
          expect(updated_bing.title).to eq("Bing")
        end
        it "should add the picture to the database when it's the second picture of a given category and the picture does not represent the category" do
          bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: false, set_user_picture: false }
          updated_darkhudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(updated_darkhudson.title).to eq("Dark Hudson")
        end
        it "should set represent_category boolean of existing picture to false when adding a new picture that represents the category" do
          bing = Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: true, set_user_picture: true }
          expect(bing.reload.represents_category).to eq(nil)
          updated_darkhudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(updated_darkhudson.title).to eq("Dark Hudson")
        end
      end
    end

    context "represents_category and represents_user tests" do
      let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
      let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
      let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)}
      before do
        sign_in charlie
      end
      context "represents_user is present and represents_category is present" do
        it "should alter represents_user and represents_category fields in existing record in database and add new record to database" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: "true", set_user_picture: "true" }
          expect(bing.reload.represents_category).to be_nil
          expect(bing.reload.represents_user).to be_nil
          dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(dark_hudson.title).to eq("Dark Hudson")
        end
      end
      context "represents_user is nil and represents_category is present" do
        it "should display a flash error message" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: true, set_user_picture: false }
          expect(flash[:error]).to eq("A picture must represent a user.")
        end
      end
      context "represents_user is nil and represents_category is nil" do
        it "should leave existing record in database unchanged and add new record to database" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: "false", set_user_picture: "false" }
          bing = Picture.select {|picture| picture.title == "Bing" }.first
          expect(bing.represents_category).to eq(cherries)
          expect(bing.represents_user).to eq(cherries.user)
          dark_hudson = Picture.select {|picture| picture.title == "Dark Hudson" }.first
          expect(dark_hudson.title).to eq("Dark Hudson")
        end
        it "should redirect to the Add a Photo page" do
          post :create, user_id: charlie.id, picture: { category_id: cherries.id, title: "Dark Hudson", location: "Boston, MA", description: "nice cherry", image_link: Rack::Test::UploadedFile.new(Rails.root.join("public/tmp/panda.jpg")), set_cat_picture: false, set_user_picture: false }
          expect(response).to redirect_to new_user_picture_path(charlie)
        end
      end
    end  
  end

  describe 'GET show' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bananas) {Fabricate(:category, name: "Bananas", user: charlie)}
    let!(:apples) {Fabricate(:category, name: "Apples", user: charlie)}
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user, id: 1)}
    let!(:bright_red_sour) {Fabricate(:picture, title: "Bright Red Sour", category: cherries, category_id: cherries.id, represents_category: nil, id: 2)}
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: nil, represents_user: nil, id: 3)}
    let!(:chiquita) {Fabricate(:picture, title: "Chiquita", category: bananas, category_id: bananas.id, represents_category: bananas)}
    let!(:mcintosh) {Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples)}
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

  context "edit, update, and delete tests" do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}
    let!(:cherries) {Fabricate(:category, name: "Cherries", user: charlie)}
    let!(:bing) {Fabricate(:picture, title: "Bing", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: cherries.user)}
    let!(:dark_hudson) {Fabricate(:picture, title: "Dark Hudson", category: cherries, category_id: cherries.id, represents_category: nil, represents_user: nil)}
    before do
      sign_in charlie
    end
    it_behaves_like "require sign in" do
      let(:action) { post :which_picture_to_edit, user_id: charlie.id, id: "" }
    end
    describe 'POST #which_picture_to_edit' do
      it "should produce a flash error when submitted without selecting a picture" do
        post :which_picture_to_edit, user_id: charlie.id, id: ""
        expect(flash[:error]).to eq("Please select a picture to edit.")
      end
      it "should redirect to the first Edit a Photo page when submitted without selecting a picture" do
        post :which_picture_to_edit, user_id: charlie.id, id: ""
        expect(response).to redirect_to edit_pictures_user_pictures_path(charlie)
      end
      it "should redirect to the second Edit a Photo page when submitted with having selected a picture" do
        post :which_picture_to_edit, user_id: charlie.id, id: bing.id, params: { id: bing.id }
        expect(response).to redirect_to edit_user_picture_path(charlie, bing)
      end
    end

    describe 'PATCH update' do
      it_behaves_like "require sign in" do
        let(:action) { patch :update, user_id: charlie.id, id: bing.id, params: { id: dark_hudson.id }, picture: { category_id: 2, title: "Bing" } }
      end
      it "should not change the 'represents_user' status when changing the 'represent_category' status from no to yes" do
        apples = Fabricate(:category, name: "Apples", user: charlie)
        mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples, represents_user: nil)
        fuji = Fabricate(:picture, title: "Fuji", category: apples, category_id: apples.id, represents_category: nil, represents_user: nil)
        patch :update, user_id: charlie.id, id: fuji.id, params: { id: fuji.id }, picture: { category_id: apples.id, title: "New Fuji", set_cat_picture: "true" }
        expect(fuji.reload.represents_category).to eq(apples)
        expect(fuji.reload.represents_user).to be_nil
      end
      it "should not change the 'represents_category' status when not changing the 'represent_category' status" do
        apples = Fabricate(:category, name: "Apples", user: charlie)
        mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples, represents_user: nil)
        fuji = Fabricate(:picture, title: "Fuji", category: apples, category_id: apples.id, represents_category: nil, represents_user: nil)
        patch :update, user_id: charlie.id, id: fuji.id, params: { id: fuji.id }, picture: { category_id: apples.id, title: "New Fuji", set_cat_picture: "false" }
        expect(fuji.reload.represents_category).to be_nil
      end
      it "should produce a flash error message if the picture represents the category and the user is trying to change the picture's category" do
        patch :update, user_id: charlie.id, id: bing.id, params: { id: dark_hudson.id }, picture: { category_id: 2, title: "Bing" }
        expect(flash[:error]).to eq("Your \"Bing\" photo currently represents the \"Cherries\" category. To move \"Bing\" to a new category, please select a new photo to represent the \"Cherries\" category.")
      end
      it "should render the edit_pictures template if the picture represents the category and the user is trying to change the picture's category" do
        patch :update, user_id: charlie.id, id: bing.id, params: { id: dark_hudson.id }, picture: { category_id: 2, title: "Bing" }
        expect(response).to redirect_to select_cat_picture_user_cat_pictures_path(charlie)
      end
      it "should produce a flash error message if the user is trying to have a picture that represents a category no longer represent that category" do
        patch :update, user_id: charlie.id, id: bing.id, params: { id: dark_hudson.id }, picture: { category_id: cherries.id, title: "Bing", set_user_picture: "true", set_cat_picture: "false" }
        expect(flash[:error]).to eq("Your \"Bing\" photo currently represents the \"Cherries\" category. Please select a new photo to represent the \"Cherries\" category.")
        expect(response).to render_template :edit_pictures
      end
      it "should produce a flash error message if the user no longer wants the photo to represent his portfolio" do
        patch :update, user_id: charlie.id, id: bing.id, params: { id: dark_hudson.id }, picture: { category_id: cherries.id, title: "Bing", set_cat_picture: "true", set_user_picture: "false" }
        expect(flash[:error]).to eq("Your \"Bing\" photo currently represents your portfolio. Please select a new photo to represent your portfolio.")
        expect(response).to render_template :edit_pictures
      end
      it "should produce a flash success message if picture has been updated" do
        patch :update, user_id: charlie.id, id: dark_hudson.id, params: { id: dark_hudson.id }, picture: { title: "Dark Hudson2" }
        expect(flash[:success]).to eq("You have successfully updated your picture \"Dark Hudson2.\"")
      end
      it "should redirect to the Show Picture page if picture has been updated" do
        patch :update, user_id: charlie.id, id: dark_hudson.id, params: { id: dark_hudson.id }, picture: { title: "Dark Hudson" }
        expect(response).to redirect_to user_picture_path(charlie, dark_hudson)
      end
      it "should update the database if the input is valid" do
        patch :update, user_id: charlie.id, id: dark_hudson.id, params: { id: dark_hudson.id }, picture: { title: "Dark Hudson2" }
        expect(dark_hudson.reload.title).to eq("Dark Hudson2")
      end
      it "should produce a flash error message if the input contains an error" do
        patch :update, user_id: charlie.id, id: dark_hudson.id, params: { id: dark_hudson.id }, picture: { title: "" }
        expect(flash[:error]).to eq("Please fix the 1 error below:")
      end
      it "should render the edit template if the input contains an error" do
        patch :update, user_id: charlie.id, id: dark_hudson.id, params: { id: dark_hudson.id }, picture: { category_id: cherries.id, title: "" }
        expect(response).to render_template :edit
      end
    end
    
    describe "POST #which_picture_to_delete" do
      it_behaves_like "require sign in" do
        let(:action) { post :which_picture_to_delete, user_id: charlie.id, id: "" }
      end
      it "should produce a flash error when submitted without selecting a picture" do
        post :which_picture_to_delete, user_id: charlie.id, id: ""
        expect(flash[:error]).to eq("Please select a photo to delete.")
        expect(response).to redirect_to delete_pictures_user_pictures_path(charlie)
      end
      it "should produce a flash error when trying to delete a photo that represents the user" do
        post :which_picture_to_delete, user_id: charlie.id, id: bing.id
        expect(flash[:error]).to eq("Your \"Bing\" photo is the photo that currently represents your portfolio. To delete \"Bing,\" please select a new photo to represent your portfolio.")
        expect(response).to render_template :edit_pictures
      end
      it "should produce a flash error when trying to delete a photo that represents the user's category" do
        apples = Fabricate(:category, name: "Apples", user: charlie)
        mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples, represents_user: apples.user)
        bright_red_sour = Fabricate(:picture, title: "Bright Red Sour", category: cherries, category_id: cherries.id, represents_category: cherries, represents_user: nil)
        post :which_picture_to_delete, user_id: charlie.id, id: bright_red_sour.id
        expect(flash[:error]).to eq("Your \"Bright Red Sour\" photo currently represents the \"Cherries\" category. To delete \"Bright Red Sour,\" please select a new photo to represent the \"Cherries\" category.")
        expect(response).to render_template :edit_pictures
      end
      it "should delete a picture and produce a flash error message" do
        post :which_picture_to_delete, user_id: charlie.id, id: dark_hudson.id
        expect(flash[:success]).to eq("Your photo \"Dark Hudson\" has been deleted.")
        expect(Picture.where(title: "Dark Hudson")).to be_empty
        expect(response).to redirect_to user_path(charlie)
      end
    end

    describe "GET delete_pictures" do
      let!(:alice) {Fabricate(:user, first_name: "Alice", last_name: "Aardvark")}
      let!(:apples) {Fabricate(:category, name: "Apples", user: alice)}
      before do
        sign_in alice
      end
      it_behaves_like "require sign in" do
        let(:action) { get :delete_pictures, user_id: alice.id }
      end
      it "should create a flash message if there are no pictures to delete" do
        get :delete_pictures, user_id: alice.id
        expect(flash[:error]).to eq("You don't have any photos to delete.")
        expect(response).to redirect_to new_user_picture_path(alice)
      end
      it "should render the Delete a Photo page if there are photos to delete" do
        mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples, represents_user: apples.user)
        fuji = Fabricate(:picture, title: "Fuji", category: apples, category_id: apples.id, represents_category: nil, represents_user: nil)
        get :delete_pictures, user_id: alice.id
        expect(response).to render_template :delete_pictures
      end
    end
  end
end