require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do

  context "Associations" do
    it { should have_many(:votes) }
    it { should have_and_belong_to_many(:tags) }
    it { should belong_to(:user) }
  end

  context "Validation Checks" do

    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user) }

    it { should respond_to(:votes) }
    it { should respond_to(:tags) }

  end

  context "Class Methods" do

    #it "should respond to role_allowed? at the class level" do
    #  Agency.should respond_to(:role_allowed?)
    #  agency = Agency.new
    #  agency.should_not respond_to(:role_allowed?)
    #end

  end

  context "Instance Methods" do

    #it { should respond_to(:active?) }

  end

end
