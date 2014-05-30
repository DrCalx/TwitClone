require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

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
end
