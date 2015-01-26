require "spec_helper"

feature "edit category" do

  scenario "successfully edit category and verify that the new category name is in the database" do
    
    log_in
    
    click_link "Edit a Category"
    expect(page).to have_content "Edit a Category"
    choose "Cherries"
    click_button "Select Category"
    fill_in "Name", with: "Updated Cherries Name"
    click_button "Update Category"
    expect(page).to have_content "You have successfully updated your category. The category is now \"Updated Cherries Name.\""
    expect(Category.where(name: "Updated Cherries Name")).to be_present
    
    log_off
  end

end