require "spec_helper"

feature "view portfolio" do

  scenario "successfully view a photographer's portfolio" do
    
    log_in
    
    expect(page).to have_content "Cherries"
    click_link "View Portfolio", match: :first
    expect(page).to have_content "Cherries"
    page.first(".picture").click
    save_and_open_page
    # expect(page).to have_content "Bing"

    # log_off
  end

end