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

  it { should be_valid }

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
end
