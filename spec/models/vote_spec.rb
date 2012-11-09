require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vote do

  context "Associations" do
    it { should belong_to(:comment) }
    it { should belong_to(:user) }
  end

  context "Validation Checks" do

    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:user) }

    it { should respond_to(:value) }

  end

  context "Class Methods" do

    #it "should respond to role_allowed? at the class level" do
    #  Agency.should respond_to(:role_allowed?)
    #  agency = Agency.new
    #  agency.should_not respond_to(:role_allowed?)
    #end

  end

  context "Instance Methods" do

    it { should respond_to(:vote_sum) }
    it { should respond_to(:up_votes) }
    it { should respond_to(:down_votes) }
    it { should respond_to(:up_vote) }
    it { should respond_to(:down_vote) }



  end

end
