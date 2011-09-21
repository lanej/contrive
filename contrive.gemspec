# -*- encoding: utf-8 -*-
require File.expand_path('../lib/contrive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joshua Lane"]
  gem.email         = ["jlane@engineyard.com"]
  gem.description   = %q{Cook up anything, any way you like}
  gem.summary       = %q{Tree-based framework for dependency resolution}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "contrive"
  gem.require_paths = ["lib"]
  gem.version       = Contrive::VERSION
end
