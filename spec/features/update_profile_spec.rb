require "spec_helper"

feature "update profile" do

  scenario "successfully update profile and verify that it has been updated" do
    
    log_in
    
    click_link "Update Profile"
    expect(page).to have_content "Update Profile"
    fill_in "Last name", with: "Chan2"
    fill_in "Current password (for confirming updates)", with: "password"
    click_button "Update Profile"
    expect(User.where(last_name: "Chan")).not_to be_present
    expect(User.where(last_name: "Chan2")).to be_present
    
    log_off
  end

end