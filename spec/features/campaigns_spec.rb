require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  describe "Listings Page" do
    it "contains a text: All Campaigns" do
      # Visit is a method from Capybara that emulates visiting a page from RSpec
      visit campaigns_path
      # page is a special object from capybara that we can do matchin on - displays as HTML page
      expect(page).to have_text("All Campaigns")
    end

    # check for a specific HTML tag
    it "contains a h2 element with text: Recent Campaigns" do
      visit campaigns_path
      # have_selector here is another matcher
      # note that h2 is in quotes because of the NOkogiri gem - usually we
      # send it as a symbol, e.g. :h2
      expect(page).to have_selector "h2", text: "Recent Campaigns"
    end

    # check attributes pulled from an object (eg. if we want to check for a title"
    it "displays a campaign's title on the page" do
      c = FactoryGirl.create(:campaign)
      visit campaigns_path
      # Expect somewhere on the page that c.title exists
      # we wrap this in RegExp and put 'i' at the end to make it a case-insensitive search
      expect(page).to have_text(/#{c.title}/i)
    end
  end
end
