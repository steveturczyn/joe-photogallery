require "spec_helper"

feature "add photo" do

  scenario "successfully add photo and verify that it has been added" do
    
    log_in
    
    click_link "Add a Photo"
    expect(page).to have_content "Add a Photo"
    choose "Cherries"
    fill_in "Title", with: "Bright Red Sour"
    fill_in "Location", with: "Boston, MA"
    fill_in "Description", with: "Beautiful cherries"
    attach_file "Name of Photo", "public/tmp/bird.jpg"
    choose "picture_represent_category_true", "No"
    choose "picture_represent_user_true", "No"
    click_button "Add Photo"
    expect(Picture.where(title: "Bright Red Sour")).to be_present
    
    log_off
  end

end