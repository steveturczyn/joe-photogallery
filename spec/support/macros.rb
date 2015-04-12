def log_in
  charlie = Fabricate(:user, password: "password", first_name: "Charlie", last_name: "Chan", id: 1)
  cherries = Fabricate(:category, name: "Cherries", user_id: charlie.id)
  bing = Fabricate(:picture, title: "Bing", categories: [cherries], represents_user: cherries.user, represents_category: cherries, id: 1)
  dark_hudson = Fabricate(:picture, title: "Dark Hudson", categories: [cherries], represents_user: nil, represents_category: nil, id: 2)
  bananas = Fabricate(:category, name: "Bananas", user: charlie)
  chiquita = Fabricate(:picture, title: "Chiquita", categories: [bananas], represents_user: nil, represents_category: bananas)
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