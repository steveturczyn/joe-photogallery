def log_in
  charlie = Fabricate(:user, password: "password", first_name: "Charlie", last_name: "Chan", id: 1)
  cherries = Fabricate(:category, name: "Cherries", user_id: charlie.id)
  bing = Fabricate(:picture, title: "Bing", category_id: cherries.id, represent_user: true, represent_category: true, id: 1)
  dark_hudson = Fabricate(:picture, title: "Dark Hudson", category_id: cherries.id, represent_user: false, represent_category: false, id: 2)
  bananas = Fabricate(:category, name: "Bananas", user: charlie)
  chiquita = Fabricate(:picture, title: "Chiquita", category_id: bananas.id, represent_user: false, represent_category: true)
  follow_links_to_sign_in
  fill_in "Email", with: charlie.email
  fill_in "Password", with: charlie.password
  click_button "Log in"
  expect(page).to have_content charlie.full_name
  charlie
end

def log_off
  click_link "Log Off"
end

def follow_links_to_sign_in
  visit root_path
  expect(page).to have_content "View Portfolio"
  click_link "Log In"
  expect(page).to have_content "Log In"
end