require 'spec_helper'

describe ApplicationController do

  controller do
    def after_sign_in_path_for(resource)
      super
    end
  end

  describe "GET #after_sign_in_path_for" do
    it "routes existing user to the User Show page" do
      angela = Fabricate(:user, first_name: "Angela", last_name: "Atkins")
      apples = Fabricate(:category, name: "Apples", user: angela)
      mcintosh = Fabricate(:picture, title: "McIntosh", category: apples, category_id: apples.id, represents_category: apples, represents_user: apples.user)
      sign_in angela
      expect(controller.after_sign_in_path_for(angela)).to eq(user_path(angela))
    end
    it "routes new user to the Add a Category page" do
      angela = Fabricate(:user, first_name: "Angela", last_name: "Atkins")
      sign_in angela
      expect(controller.after_sign_in_path_for(angela)).to eq(new_user_category_path(angela))
    end
  end
end