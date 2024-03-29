require File.dirname(__FILE__) + '/test_helper'

class TestLayers < Test::Unit::TestCase
  def setup
    series = Dataset::Series.new #(:measure => Dataset::Measure::UnitDeltas)
    series.add([2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157], [2000,100])
    d = Dataset::Dataset.new(:title => "Test Data").add(series)
    chart = Chart::Chart.new(:dataset => d, :theme => Chart::Theme::Default.new).build
    @layer = Chart::Layer::Line.new(:chart => chart, :series => series)
  end

  def test_layer
    assert_kind_of(Chart::Layer::Line, @layer)
  end

  def test_sort_order
    assert_equal(Dataset::Chron::YYYY.new(2000), @layer.points.first[0])
    assert_equal(Dataset::Chron::YYYY.new(2005), @layer.points.last[0])
  end
end
