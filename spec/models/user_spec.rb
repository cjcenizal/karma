# spec/models/user_spec.rb

require 'spec_helper'

describe User do
	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
	end
	it "is invalid w/o a first name" do
		FactoryGirl.build(:user, first_name: nil).should_not be_valid
	end
	it "is invalid w/o a last name" do
		FactoryGirl.build(:user, last_name: nil).should_not be_valid
	end
	it "is invalid w/o a user name" do 
		FactoryGirl.build(:user, username: nil).should_not be_valid
	end
	it "does not allow duplicate usernames" do
		FactoryGirl.create(:user, username: "John")
		FactoryGirl.build(:user, username: "John").should_not be_valid
	end
	it "is invalid w/o a email" do 
		FactoryGirl.build(:user, email: nil).should_not be_valid
	end
	it "does not allow duplicate usernames" do
		FactoryGirl.create(:user, email: "John@c.com")
		FactoryGirl.build(:user, email: "John@c.com").should_not be_valid
	end
	it "returns a user's full name as a strong" do
		contact = FactoryGirl.create(:user, first_name: "John", last_name: "Doe")
		contact.name.should == "John Doe"
	end

end

