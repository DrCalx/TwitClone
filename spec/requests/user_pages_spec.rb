require 'spec_helper'

describe "User" do
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
				fill_in "Name", 			with: "Test User"
				fill_in "Email", 			with: "test@test.com"
				fill_in "Password", 		with: "Pass123"
				fill_in "Confirm Password", with: "Pass123"
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

	describe "edit" do
		#create pre-existing user
		let(:user) { FactoryGirl.create(:user) }
		before do
			valid_signin user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Update your profile") }
			it { should have_title("Edit user") }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name)	{ "New Name" }
			let(:new_email) { "new@email.com" }
			before do 
				fill_in "Name", 			with: new_name
				fill_in "Email", 			with: new_email
				fill_in "Password", 		with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end
end
