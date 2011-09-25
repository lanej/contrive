require 'spec_helper'

describe Contrive do
  it "should build from one action" do
    Contrive::Action.build do 
      produce :team => {:captain => {}}
      resolve do |model|
        {:team => {:captain => {:name => "bob"}}}
      end
    end
    
    team = Contrive.resolve(:team)
    team[:captain].should_not be_nil
  end
end