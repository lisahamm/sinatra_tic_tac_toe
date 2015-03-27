require 'rspec'
require 'rack/test'

root = File.expand_path(File.dirname(__FILE__) + '/../')

lib = root + '/lib'
spec = root + '/spec'

$:.unshift(lib) unless $:.include?(lib)
$:.unshift(spec) unless $:.include?(spec)


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
