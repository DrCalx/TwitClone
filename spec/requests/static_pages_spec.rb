require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    it "should contain the words 'Sample App' somewhere" do
    	visit '/static_pages/home'
    	expect(page).to have_content('Sample App')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("RoR Tutorial Sample App | Home")
    end
  end

  describe "Help Page" do
  	it "should contain the word 'Help'" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  	end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("RoR Tutorial Sample App | Help")
    end
  end

  describe "About Page" do
    it "should contain the phrase 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("RoR Tutorial Sample App | About")
    end
  end
end
