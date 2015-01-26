require "spec_helper"

feature "delete photo" do

  scenario "successfully delete photo and verify that the photo has been deleted" do
    
    log_in
    
    click_link "Delete a Photo"
    expect(page).to have_content "Delete a Photo"
    choose "Dark Hudson"
    click_button "Select Picture"
    expect(page).to have_content "Your photo \"Dark Hudson\" has been deleted."
    expect(Picture.where(title: "Dark Hudson")).not_to be_present
    
    log_off
  end

end