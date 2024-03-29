require "test/unit"

require "mocha"

class Test::Unit::TestCase #:nodoc:
  def fixture(name)
    File.open(File.dirname(__FILE__) + "/fixtures/" + self.class.name + "/" + name)
  end

  def testdata(name)
    File.open(File.dirname(__FILE__) + "/testdata/#{name}").read
  end
end

require "chart"
