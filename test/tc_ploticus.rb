require File.dirname(__FILE__) + '/test_helper'

require "chart/render/ploticus"

class TestPloticus < Test::Unit::TestCase
  def setup
    series = Dataset::Series.new
    series.add([2000,100], [2001,101], [2002, 120], [2003, -140], [2004, 130], [2005, 157])
    dataset = Dataset::Dataset.new(:title => "Test Data").add(series)
    @chart = Chart::Chart.new(:dataset => dataset, :theme => Chart::Theme::Default.new).build
  end

  def test_render
    r = Chart::PloticusBarGIFRenderer.new
    rendering = r.render(@chart)
    assert_kind_of(Chart::Rendering, rendering)
    assert_equal("image/gif", rendering.mimetype)
  end
end