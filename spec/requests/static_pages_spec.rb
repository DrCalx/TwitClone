require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Contact Page" do
    before { visit contact_path }

    let(:heading)     { 'Contact' }
    let(:page_title)  { 'Contact' }

    it_should_behave_like "static pages"
  end

  describe "Home Page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title(full_title("Home")) }
  end

  describe "Help Page" do
    before { visit help_path }
  	it { should have_content('Help') }
    it { should have_title(full_title("Help")) }
  end

  describe "About Page" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title(full_title("About")) }
  end
end
