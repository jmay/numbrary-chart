require File.dirname(__FILE__) + '/test_helper'

class TestLayers < Test::Unit::TestCase
  def setup
    series = Dataset::Series.new #(:measure => Dataset::Measure::UnitDeltas)
    series.add([2000,100], [2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157])
    d = Dataset::Dataset.new(:title => "Test Data").add(series)
    chart = Chart::Chart.new(:dataset => d, :theme => Chart::Theme::Default.new).build
    @layer = Chart::Layers::Line.new(:chart => chart, :series => series)
  end

  def test_layer
    assert_kind_of(Chart::Layers::Line, @layer)
  end
end
