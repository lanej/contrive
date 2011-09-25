require "contrive/version"

module Contrive
  class Action
    attr_reader :produces
    def produce(model)
      @produces = model
    end
    def self.actions
      @actions ||= []
    end
    def self.build(&block)
      actions << Contrive::Action.new.tap{|ac| ac.instance_eval(&block)}
    end
    def self.resolve(produce)
      actions.detect{|action| action.produces.keys.first == produce}.create_resolution(produce)
    end
    def create_resolution(model)
      resolutions.find{|resolution| resolution.call(model)}
    end
    def resolutions
      @resolutions ||= []
    end
    def resolve(&block)
      resolutions << block
    end
  end
  
  def self.resolve(model)
    Contrive::Action.resolve(model)
  end
end
