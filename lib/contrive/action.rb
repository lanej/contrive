module Contrive
  class Action
    def self.reset!
      @actions = []
    end
    def resolve(model)
      Contrive.resolve(model)
    end
    def self.actions
      @actions ||= []
    end
    def self.build(&block)
      actions << Contrive::Action.new.tap{|ac| ac.instance_eval(&block)}
    end
    def self.resolve(produce)
      matching_actions = actions.select{|action| action.produces.complement_to?(produce)}
      answer = nil
      matching_actions.detect do |action|
        action.unresolved_demands.each{|demand| action.resolve_demand(demand, Contrive.resolve(demand))}
        resolution, answer = action.create_resolution(action.produces)
      end
      answer
    end

    attr_reader :produces, :demands
    def produce(model)
      model = model.new if model.is_a?(Class)
      @produces = model
    end
    def demand(*models)
      unresolved_demands.concat(models)
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
    def create(&block)
      resolutions << block
    end
  end
end
