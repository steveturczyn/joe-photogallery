require 'spec_helper'

describe BiosController do
  describe 'GET index' do
    let!(:charlie) {Fabricate(:user, first_name: "Charlie", last_name: "Chan", id: 1)}

    it "retrieves User object requested by params" do
      get :index, user_id: charlie.id
      expect(assigns(:show_user)).to eq(charlie)
    end
  end
end