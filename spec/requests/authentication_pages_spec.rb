require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }
		it { should have_content('Sign in') }
		it { should have_title('Sign in') }

		describe "with invalid info" do
			before { click_button "Sign in" }
			it { should have_selector('div.alert.alert-error') }

			describe "visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end

			describe "after submission" do
				it { should have_title('Sign in') }
				it { should have_content('Invalid') }
			end
		end

		describe "with valid info" do
			let(:factoryUser) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: factoryUser.email.upcase
				fill_in "Password", with: factoryUser.password
				click_button "Sign in"
			end

			it { should have_title(factoryUser.name) }
			it { should have_link('Profile', 		href:user_path(factoryUser)) }
			it { should have_link('Sign out', 		href:signout_path) }
			it { should_not have_link('Sign in', 	href:signin_path) }
		end
	end
end
