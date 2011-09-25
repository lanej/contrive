require "contrive/version"

module Contrive
  def self.resolve(model)
    Contrive::Action.resolve(model)
  end
  class Action
    def self.reset!
      @actions = []
    end
    def self.actions
      @actions ||= []
    end
    def self.build(&block)
      actions << Contrive::Action.new.tap{|ac| ac.instance_eval(&block)}
    end
    def self.resolve(produce)
      resolution, answer = actions.detect{|action| action.produces.keys.first == produce}.create_resolution(produce)
      Contrive::Model.new(answer)
    end

    attr_reader :produces
    def produce(model)
      @produces = model
    end
    def create_resolution(model)
      answer = nil
      resolution = resolutions.find{|resolution| answer = resolution.call(model)}
      [resolution, answer]
    end
    def resolutions
      @resolutions ||= []
    end
    def resolve(&block)
      resolutions << block
    end
  end
  class Model
    attr_reader :type, :attributes
    def initialize(hash)
      @type, @attributes = hash.keys.first, hash[hash.keys.first]
    end
    def [](key)
      attributes[key]
    end
  end
end
