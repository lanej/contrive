require 'spec_helper'

describe Contrive do
  before(:each) do
    Contrive::Action.reset!
    Contrive::Model.reset!
  end
  it "should build from one action" do
    class Team
      include Contrive::Model
      property :name
    end
    Contrive.build do
      produce Team
      create do |model|
        Team.new(:name => "bob")
      end
    end

    team = Contrive.resolve(Team)
    team.name.should eql "bob"
  end
  it "should build from two actions" do
    class Team
      include Contrive::Model
    end
    class Captain
      include Contrive::Model
    end
    Contrive.build do
      produce Team.new(:captain => Captain.new)
      create do |team|
        Team.new(:captain => resolve(team.captain))
      end
    end
    Contrive.build do
      produce Captain
      create do |model|
        Captain.new(:name => "bob")
      end
    end

    team = Contrive.resolve(Team)
    team.captain.name.should eql "bob"
  end
  it "should compose multiple demands" do
    class Marriage
      include Contrive::Model
    end
    class Wife
      include Contrive::Model
    end
    class Husband
      include Contrive::Model
    end

    Contrive.build do
      produce Marriage.new(:wife => Wife.new, :husband => Husband.new)

      create do |model|
        Marriage.new(:wife => resolve(Wife.new), :husband => resolve(Husband.new))
      end
    end
    Contrive.build do
      produce Husband
      create do |model|
        Husband.new(:name => "bob")
      end
    end
    Contrive.build do
      produce Wife
      create do |model|
        Wife.new(:name => "barb")
      end
    end

    marriage = Contrive.resolve(Marriage)
    marriage.husband.name.should eql "bob"
    marriage.wife.name.should eql "barb"
  end
  it "should match correct producer" do
    class Donor
      include Contrive::Model
    end
    Contrive.build do
      produce Donor.new(:name => "gary", :type => "a")
      create {|donor| Donor.new(:name => "gary", :type => "a")}
    end
    Contrive.build do
      produce Donor.new(:name => "frank", :type => "b")
      create {|donor| Donor.new(:name => "frank", :type => "b")}
    end
    donor = Contrive.resolve(Donor.new(:type => "b"))
    donor.type.should eql "b"
    donor.name.should eql "frank"
  end
end
