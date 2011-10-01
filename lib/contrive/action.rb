module Contrive
  class Action
    class InvalidResolution < Exception; end
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
      matching_actions = actions.select{|action| action.produces.complement_to?(produce)}
      answer = nil
      matching_actions.detect do |action|
        resolution, answer = action.create_resolution(action.produces.merge(produce))
        fail(InvalidResolution) unless answer.complement_to?(produce)
      end
      answer
    end

    attr_reader :produces
    def produce(model)
      model = model.new if model.is_a?(Class)
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
    def create(&block)
      resolutions << block
    end
    def resolve(model)
      Contrive.resolve(model)
    end
  end
end
