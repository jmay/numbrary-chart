require 'rspec/autorun'
require File.expand_path('../../lib/chart', __FILE__)

# require "spec"

# Spec::Runner.configure do |config|
#   config.mock_with :mocha

#   # config.use_transactional_fixtures = true
#   # config.use_instantiated_fixtures  = false
#   # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

#   # You can declare fixtures for each behaviour like this:
#   #   describe "...." do
#   #     fixtures :table_a, :table_b
#   #
#   # Alternatively, if you prefer to declare them only once, you can
#   # do so here, like so ...
#   #
#   #   config.global_fixtures = :table_a, :table_b
#   #
#   # If you declare global fixtures, be aware that they will be declared
#   # for all of your examples, even those that don't use them.
# end

def testdata(testname)
  f = File.open(File.expand_path("../testdata/#{testname}", __FILE__)) rescue nil
  f ||= File.open(File.expand_path("../../test/testdata/#{testname}", __FILE__))
  f.read
end

# $LOAD_PATH.unshift(File.dirname(__FILE__) + "/../lib")
# require "chart"
