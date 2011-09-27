module Contrive
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
      klass.send(:include, ModelExt)
    end
  end
end
