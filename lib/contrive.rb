require "contrive/version"

module Contrive
  $:.unshift File.expand_path(File.join("..","..", "lib"), __FILE__)
  autoload :Action, "contrive/action"
  autoload :Model, "contrive/model"
  autoload :ModelExt, "contrive/model_ext"
  
  def self.resolve(model)
    model = model.new if model.is_a?(Class)
    Contrive::Action.resolve(model)
  end
  def self.build(&block)
    Contrive::Action.build(&block)
  end
end
