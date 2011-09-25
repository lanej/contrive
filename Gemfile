source 'http://rubygems.org'

gemspec

# optional development dependencies
require 'rbconfig'

if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '~> 0.4.0'
  gem 'growl',      '~> 1.0.3'
end
if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '~> 0.8.5'
  gem 'libnotify',  '~> 0.1.3'
end

gem 'rake'
gem 'rspec'
gem 'guard-rspec'
gem 'guard-bundler'