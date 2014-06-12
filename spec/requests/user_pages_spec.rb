require 'spec_helper'

describe "UserPages" do
	subject { page }
	describe "Signup page" do
		before { visit signup_path }
		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign Up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end

	describe "signup" do
		before { visit signup_path }
		let(:submit) { "Create account" }

		describe "with blank information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title("Sign Up") }
				it { should have_content("error") }
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", 	with: "Test User"
				fill_in "Email", 	with: "test@test.com"
				fill_in "Password", 	with: "Pass123"
				fill_in "Confirmation", with: "Pass123"
			end

			it "should create user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving user" do
				before { click_button submit }
				let(:newUser) { User.find_by(email: 'test@test.com') } #index on email

				it { should have_link('Sign out') }
				it { should have_title(newUser.name) }
				it { should have_selector('div.alert.alert-success', text: 'Congrats') }
			end
		end
	end
end
