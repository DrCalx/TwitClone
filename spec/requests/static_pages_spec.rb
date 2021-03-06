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
    
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        valid_signin(user)
        FactoryGirl.create(:micropost, user:user, content:"Test Alpha")
        FactoryGirl.create(:micropost, user:user, content:"test Beta")
        visit root_path
      end

      it "should render user feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "show followed / follower counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("1 follower", href: followers_user_path(user)) }
        it { should have_link("0 following", href: following_user_path(user)) }
      end
    end
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
