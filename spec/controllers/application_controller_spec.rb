require 'spec_helper'

describe ApplicationController do
  describe "GET #after_sign_in_path_for" do
    it "routes existing user to the User Show page" do
      angela = Fabricate(:user, first_name: "Angela", last_name: "Atkins")
      apples = Fabricate(:category, name: "Apples", user: angela)
      mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represent_category: true, represent_user: true)
      sign_in angela
      controller.send(:after_sign_in_path_for,(:user))
      expect(response).to redirect_to user_path(angela)
    end
    # it "routes new user to the Add a Category page" do
    #   angela = Fabricate(:user, first_name: "Angela", last_name: "Atkins")
    #   sign_in angela
    #   get :after_sign_in_path_for, id: angela.id
    #   expect(response).to redirect_to new_user_category_path
    # end
  end
end