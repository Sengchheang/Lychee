require_relative "spec_helper"

feature "Homepage" do
  background do
    visit "/"
  end

  scenario "provides deep links" do
    expect(page).to have_title("Home")
  end
end
