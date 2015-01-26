shared_examples "require sign in" do
  it "redirects to the sign-in page" do
    sign_out(:user)
    action
    expect(response).to redirect_to '/users/sign_in'
  end
end