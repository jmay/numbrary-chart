require File.dirname(__FILE__) + '/test_helper'

# require "rexml/document"

class TestChart < Test::Unit::TestCase
  def setup
    series = Dataset::Series.new
    series.add([2000,100], [2001,101], [2002, 120], [2003, -140], [2004, 130], [2005, 157])
    @dataset = Dataset::Dataset.new(:title => "Test Data")
    @dataset.add(series)
    @chart = Chart::Chart.new(:dataset => @dataset, :theme => Chart::Theme::Default.new)
    @chart.build

    # series2 = Dataset::Series.new(:measure => Dataset::Measure::UnitDeltas)
    series2 = Dataset::Series.new(:measure => Dataset::Measure.new(:diff => true))
    series2.add([2000,100], [2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157])
    dataset2 = Dataset::Dataset.new(:title => "Deltas Test")
    dataset2.add(series2)
    @chart2 = Chart::Chart.new(:dataset => dataset2, :theme => Chart::Theme::Default.new)
    @chart2.build
  end

  def test_new
    assert_not_nil(@chart.dataset)
    assert_not_nil(@chart.theme)

    assert_equal(2000, @chart.chron_axis.min.value)
    # assert_equal(2000, @chart.layers[0].bars.first.x.value)
    assert_equal(2005, @chart.chron_axis.max.value)
    # assert_equal(2005, @chart.layers[0].bars.last.x.value)
  end

  def test_first
    assert(@chart.layers.size == 1, "This chart should have exactly one data layer.")
    # assert_not_nil(@chart.canvas)
    assert_not_nil(@chart.chron_axis)
    assert_not_nil(@chart.yaxis)
    # assert_not_nil(@chart.legend)
  end

  # def test_render
  #   renderer = Chart::Renderer.new(:theme => @chart.theme, :indent => 2)
  #   renderer.render(@chart)
  #   xmldoc = REXML::Document.new(renderer.target!)
  #   assert_not_nil(xmldoc.root.elements["g[@id='canvas']"])
  #   assert_not_nil(xmldoc.root.elements["defs/style"].cdatas[0])  # check that CSS is there
  #   bars = xmldoc.root.elements["g[@id='data']/g[@class='layer']"]
  #   assert_not_nil(bars)
  #   # bar 4 (XML count starts from zero) should run negative, i.e. height should be >0 since
  #   # SVG coords puts Y=0 at the top
  #   # puts xmldoc.root
  #   # puts bars
  #   # puts bars.elements[4]
  #   # puts bars.elements[4].attributes["y"]
  #   assert_operator(bars.elements[3].attributes["y"].to_i, :<, 0)
  #   assert_operator(bars.elements[3].attributes["height"].to_i, :>, 0)
  #   assert_equal(@chart.adjust_y(0, renderer).to_i, bars.elements[4].attributes["y"].to_i)
  #   assert_operator(bars.elements[4].attributes["height"].to_i, :>, 0)
  #   # File.new("out.svg", "w") << renderer.target!
  # end

  # def test_layers
  #   assert_equal(Chart::Layers::Bar, @chart.layers[0].class)
  # end

  # def test_line
  #   assert_equal(Chart::Layers::Line, @chart2.layers[0].class)
  #   renderer = Chart::Renderer.new(:theme => @chart2.theme, :indent => 2)
  #   renderer.render(@chart2)
  #   assert_match(/polyline/, renderer.target!)
  # end

  def test_constraints
    chart = Chart::Chart.new(:dataset => @dataset,
                             :constraints => { :from => @dataset.series[0].chron.new(2002) })
    chart.build
    assert_equal(2002, chart.chron_axis.min.value)
    assert_equal(2002, chart.layers[0].bars.first.x.value)
    assert_equal(2005, chart.chron_axis.max.value)
    assert_equal(2005, chart.layers[0].bars.last.x.value)
  end

  # test that constraints passed to Chart#new are reflected in the chart#series and #axes
  # e.g. chart#xaxis.minvalue <= lower chron constraint (where x axis is time)

  # test that Y axis tick labels are formatted correctly, e.g. commas and dollar signs
end
