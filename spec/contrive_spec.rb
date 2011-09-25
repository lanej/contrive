require 'spec_helper'

describe Contrive do
  before(:each) do
    Contrive::Action.reset!
  end
  it "should build from one action" do
    Contrive::Action.build do 
      produce :team => {:captain => {}}
      resolve do |model|
        {:team => {:captain => {:name => "bob"}}}
      end
    end
    
    team = Contrive.resolve(:team)
    team[:captain][:name].should eql "bob"
  end
end