require "contrive/version"

module Contrive
  def self.resolve(model)
    model = model.new if model.is_a?(Class)
    Contrive::Action.resolve(model)
  end
  def self.build(&block)
    Contrive::Action.build(&block)
  end
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
  module Model
    def self.reset!
      decendants.each{|decendant| Object.send(:remove_const, decendant.to_s.to_sym)}
      @decendants = []
    end
    def self.decendants
      @decendants ||= []
    end
    def self.included(klass)
      decendants << klass
      class << klass
        def attributes
          @attributes ||= []
        end
        def property(name)
          attributes << name
        end
      end
      klass.class_eval do
        extend Forwardable
        def_delegators :@attributes, :[], :[]=, :keys, :key?, :inject
        
        def initialize(attributes={})
          @attributes = attributes
        end
        
        def attributes
          @attributes || {}
        end
        
        def method_missing(method, *args, &block)
          if key?(method)
            self[method]
          else
            raise "undefined method #{method}"
          end
        end

        def complement_to?(request)
          self.kind_of?(request.class) && request.inject(true){|r,(k,v)| r &= (self[k] === v)}
        end
        
        def ===(request)
          request = self[request] unless request.is_a?(Model)
          complement_to?(request)
        end
      end
    end
  end
end
