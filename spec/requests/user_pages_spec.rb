require 'spec_helper'

describe "User" do
	subject { page }

	describe "index" do
		before do 
			valid_signin FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Jack", email: "jack@example.com")
			FactoryGirl.create(:user, name: "Jill", email: "jill@example.com")
			visit users_path
		end

		it { should have_title('All users') }
		it { should have_content('All users') }

		describe "with pagination" do

			before(:all) {35.times { FactoryGirl.create(:user)}}
			after (:all) {User.delete_all}

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page:1).each do |user|
					expect(page).to have_selector('li', text: user.name)
				end
			end
		end
		describe "delete links" do
			it { should_not have_link('delete') }

			describe "as an admin" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					valid_signin admin
					visit users_path
				end

				it { should have_link('delete', href:user_path(User.first)) }
				it "deleting another user" do
					expect do
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end

	end

	describe "Signup page" do
		before { visit signup_path }
		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign Up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user:user, content:"First post") }
		let!(:m2) { FactoryGirl.create(:micropost, user:user, content:"Second post") }

		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end

		describe "follow buttons" do
			let(:other_user) { FactoryGirl.create(:user) }
			before { valid_signin user }

			describe "following a user" do
				before { visit user_path(other_user) }

				it "should increment followed user count" do
					expect { click_button "Follow" }.to change(user.followed_users, :count).by(1)
				end

				it "should increment other user's followers count" do
					expect { click_button "Follow" }.to change(other_user.followers, :count).by(1)
				end

				describe "should toggle the button" do
					before { click_button "Follow" }
					it { should have_xpath("//input[@value='Unfollow']") }
				end
			end

			describe "unfollowing a user" do
				before do
					user.follow!(other_user)
					visit user_path(other_user)
				end

				it "should decrement followed user count" do
					expect { click_button "Unfollow" }.to change(user.followed_users, :count).by(-1)
				end

				it "should decrement other user follower count" do
					expect {click_button "Unfollow"}.to change(other_user.followers, :count).by(-1)
				end

				describe "should toggle the button back to 'Follow'" do
					before { click_button "Unfollow" }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end
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

	describe "following/followers" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		before { user.follow!(other_user) }

		describe "followed Users" do
			before do
				valid_signin user
				visit following_user_path(user)
			end
		end

		describe "following" do
		end
	end
end
