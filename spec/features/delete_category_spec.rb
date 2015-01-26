require "spec_helper"

feature "delete category" do

  scenario "successfully delete category and verify that it has been deleted" do
    
    log_in
    
    click_link "Delete a Category"
    expect(page).to have_content "Delete a Category"
    choose "Bananas"
    click_button "Select Category"
    expect(page).to have_content "Your pictures have been moved to the \"Uncategorized\" category."
    expect(Category.where(name: "Bananas")).not_to be_present
    expect(Category.where(name: "Uncategorized")).to be_present
    
    log_off
  end

end