require "spec_helper"

feature "edit photo" do

  scenario "successfully edit photo and verify that the photo gets updated correctly" do
    
    sign_in
    
    click_link "Edit a Photo"
    expect(page).to have_content "Edit a Photo"
    choose "Bing"
    click_button "Select Picture"
    expect(page).to have_content "Upload Replacement Photo?"
    fill_in "Title", with: "Updated Bing Title"
    click_button "Update Photo"
    expect(page).to have_content "You have successfully updated your picture \"Updated Bing Title.\""
    expect(Picture.where(title: "Updated Bing Title")).to be_present
    
    # sign_out
  end

end