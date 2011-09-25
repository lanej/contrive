guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', :version => 2, :cli => '-c' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/contrive/(.+)\.rb$})      { |m| "spec/#{m[1]}_spec.rb" }
  watch('lib/contrive.rb')                { "spec" }
  watch('spec/spec_helper.rb')            { "spec" }
end
