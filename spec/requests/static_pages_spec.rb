require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Contact Page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title("RoR Tutorial Sample App | Contact") }
  end

  describe "Home Page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title("RoR Tutorial Sample App | Home") }
  end

  describe "Help Page" do
    before { visit help_path }
  	it { should have_content('Help') }
    it { should have_title("RoR Tutorial Sample App | Help") }
  end

  describe "About Page" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title("RoR Tutorial Sample App | About") }
  end
end
