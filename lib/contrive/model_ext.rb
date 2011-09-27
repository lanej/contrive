module Contrive
  module ModelExt
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
