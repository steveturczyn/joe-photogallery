# def set_current_user(user=nil)
#   session[:user_id] = (user || Fabricate(:user)).id
# end

# def current_user
#   User.find(session[:user_id])
# end

# def clear_current_user
#   session[:user_id] = nil
# end

def sign_in
  charlie = Fabricate(:user, password: "password")
  cherries = Fabricate(:category, name: "Cherries", user: charlie)
  bing = Fabricate(:picture, title: "Bing", category: cherries, represent_user: true, represent_category: true)
  follow_links_to_sign_in
  fill_in "Email", with: charlie.email
  fill_in "Password", with: charlie.password
  click_button "Log in"
  expect(page).to have_content charlie.full_name
  charlie
end

# def sign_out
#   click_link "Log Off"
# end

def follow_links_to_sign_in
  visit root_path
  expect(page).to have_content "View Portfolio"
  click_link "Log In/Sign Up"
  expect(page).to have_content "Log In"
end