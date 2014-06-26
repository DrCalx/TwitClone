require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com", 
														password: "password", password_confirmation: "password") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }
	it { should respond_to(:relationships) }
	it { should respond_to(:followed_users) }
	it { should respond_to(:reverse_relationships) }
	it { should respond_to(:followers) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }

	it { should be_valid }
	it { should_not be_admin }

	describe "with admin set to true" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when password is not present" do
		before { @user = User.new(name: "me", email: "me@myself.org", password: " ", password_confirmation: " ") }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password is too short" do
		before { @user.password = @user.password_confirmation = "12345" }
		it { should_not be_valid }
	end

	describe "should not allow blank names" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "should not allow blank emails" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "should not allow long names" do
		before { @user.name = 'a' * 51 }
		it { should_not be_valid }
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "micropost associations" do
		before { @user.save }
		#Note how we're creating the older one first, so it will have a lower id
		let!(:older_post) do
			FactoryGirl.create(:micropost, user:@user, created_at: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:micropost, user:@user, created_at: 1.hour.ago)
		end

		it "should return posts in the correct order" do
			expect(@user.microposts.to_a).to eq [newer_post, older_post]
		end

		it "should destroy posts when destroyed" do
			microposts = @user.microposts.to_a
			@user.destroy
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		describe "status" do
			let(:unfollowed_post) {FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))}
			let(:followed_user) { FactoryGirl.create(:user) }

			before do
				@user.follow(followed_user)
				3.times { followed_user.microposts.create!(content: "Test Post") }
			end

			its(:feed) { should include(newer_post) }
			its(:feed) { should include(older_post) }
			its(:feed) { should_not include(unfollowed_post) }
			its(:feed) do
				followed_user.microposts.each do |post|
					should include(post)
				end
			end
		end
	end

	describe "following" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			@user.save
			@user.follow!(other_user)
		end

		it { should be_following(other_user) }
		its(:followed_users) { should include(other_user) }

		describe "followed user" do
			subject { other_user }
			its(:followers) { should include(@user) }
		end

		describe "then unfollowing" do
			before { @user.unfollow!(other_user) }
			it { should_not be_following(other_user) }
			its(:followed_users) { should_not include(other_user) }
		end
	end
end
