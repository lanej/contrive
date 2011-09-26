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
      matching_actions = actions.select{|action| action.produces.type == produce}
      answer = nil
      matching_actions.detect do |action|
        action.unresolved_demands.each{|demand| action.resolve_demand(demand, Contrive::Action.resolve(demand))}
        resolution, answer = action.create_resolution(produce)
      end
      Contrive::Model.new(answer)
    end

    attr_reader :produces, :demands
    def produce(model)
      model = {model => {}} if model.is_a?(Symbol)
      @produces = Contrive::Model.new(model)
    end
    def demand(model)
      unresolved_demands << model
    end
    def unresolved_demands
      @unresolved_demands ||= []
    end
    def resolve_demand(key, value)
      demands[key] = value
    end
    def demands
      @demands ||= {}
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
  class Model < Hash
    attr_reader :type, :attributes
    def initialize(hash)
      @type = hash.keys.first
      self.merge!(hash[hash.keys.first])
    end
  end
end
