require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }
		it { should have_content('Sign in') }
		it { should have_title('Sign in') }

		describe "with invalid info" do
			before { click_button "Sign in" }
			it { should have_error_message('Invalid') }

			describe "visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message('Invalid') }
			end

			describe "after submission" do
				it { should have_title('Sign in') }
				it { should have_content('Invalid') }
			end
		end

		describe "with valid info" do
			let(:factoryUser) { FactoryGirl.create(:user) }
			before { valid_signin(factoryUser) }

			it { should have_title(factoryUser.name) }
			it { should have_link('Users',			href:users_path) }
			it { should have_link('Profile', 		href:user_path(factoryUser)) }
			it { should have_link('Settings', 		href:edit_user_path(factoryUser)) }
			it { should have_link('Sign out', 		href:signout_path) }
			it { should_not have_link('Sign in', 	href:signin_path) }
		end
	end

	describe "authorization" do
		describe "for users not signed in" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in Users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting an update" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) } #Testing for redirect instead of title seems... smarter
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') } #So, is it better to test the title, or test for the actual redirect?
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { should have_title('Sign in') }
				end
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					#at this poitn i should get redirected to sign in page
					fill_in "Email", 	with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				describe "after signing in" do
					it "should render desired page" do
						expect(page).to have_title("Edit user")
					end
				end
			end

			describe "in Microposts controller" do
				describe "submitting to the create action" do
					before { post microposts_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "in the Relationships controller" do
				describe "submitting tot he create action" do
					before { post relationships_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submittnig to the destroy action" do
					before { delete relationships_path(1) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@user.com") }
			before{ valid_signin user, no_capybara: true }

			describe "submit a GET to Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submit a PATCH to Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { valid_signin non_admin, no_capybara: true }

			describe "submitting DELETE request to Users#destroy" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end
	end
end
