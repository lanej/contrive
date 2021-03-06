require 'spec_helper'

describe Contrive::Model do
  before(:each) do
    Contrive::Model.reset!
  end
  describe do
    it "should complement application with additional params" do
      class Donor
        include Contrive::Model
      end
      applicant = Donor.new(:name => "frank", :type => "b")
      request = Donor.new(:type => "b")
      applicant.should be_a_complement_to request
    end
    it "should not complement application with conflicting params" do
      class Donor
        include Contrive::Model
      end
      applicant = Donor.new(:name => "frank", :type => "a")
      request = Donor.new(:type => "b")
      applicant.should_not be_a_complement_to request
    end
    it "should complement application with additonal model" do
      class Donor; include Contrive::Model; end
      class Bank; include Contrive::Model; end
      application = Donor.new(:bank => Bank.new) 
      request = Donor.new(:type => "b", :bank => Bank.new(:name => "hughey"))
      application.should be_a_complement_to request
    end
  end
end
