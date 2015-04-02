require 'rspec'
require 'rack/test'

root = File.expand_path(File.dirname(__FILE__) + '/../')

lib = root + '/lib'
spec = root + '/spec'

$:.unshift(lib) unless $:.include?(lib)
$:.unshift(spec) unless $:.include?(spec)


RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner[:sequel, {:connection => Sequel.connect('postgres://localhost/tictactoe_test')}]
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
