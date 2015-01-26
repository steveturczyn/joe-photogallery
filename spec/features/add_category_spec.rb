require "spec_helper"

feature "add category" do

  scenario "successfully add category and verify that it has been added" do
    
    log_in
    
    click_link "Add a Category"
    expect(page).to have_content "Add a Category"
    fill_in "Name of new category", with: "Apples"
    click_button "Add Category"
    expect(Category.where(name: "Apples")).to be_present
    
    log_off
  end

end