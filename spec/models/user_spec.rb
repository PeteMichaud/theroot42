require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  context "Associations" do
    it { should have_many(:comments) }
    it { should have_many(:votes) }
  end

  context "Validation Checks" do

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:account_type) }

    it { should respond_to(:password) }
    it { should respond_to(:birthdate) }
    it { should respond_to(:location) }
    it { should respond_to(:location_link) }
    it { should respond_to(:avatar) }
    it { should respond_to(:active) }

  end

  context "Class Methods" do

    #it "should respond to role_allowed? at the class level" do
    #  Agency.should respond_to(:role_allowed?)
    #  agency = Agency.new
    #  agency.should_not respond_to(:role_allowed?)
    #end

  end

  context "Instance Methods" do

    it { should respond_to(:active?) }
    it { should respond_to(:activate) }

  end

end
