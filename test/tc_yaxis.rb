require File.dirname(__FILE__) + '/test_helper'

$text1 = <<_EOT_
2005    e             11048.625   3.22%           12455.825
2004    e             10703.500   3.91%           11712.475
2003    e             10301.100   2.51%           10960.750
2002    e             10048.850   1.60%           10469.600
2001    r              9890.650   0.75%           10127.950
2000    e              9816.950   3.66%            9816.975
_EOT_

$text2 = <<_EOT_
03/2004	-13
04/2004	-61
05/2004	43
06/2004	12
07/2004	6
08/2004	31
09/2004	49
10/2004	19
11/2004	-69
12/2004	32
01/2005	-37
02/2005	38
03/2005	-17
04/2005	39
05/2005	0
06/2005	36
07/2005	0
08/2005	19
09/2005	-31
10/2005	33
11/2005	71
12/2005	-4
01/2006	52
02/2006	-3
_EOT_

# Foreign Enrollment dataset from http://opendoors.iienetwork.org/?p=89192
$text3 = <<_EOT_
1954/55	34,232
1959/60	48,486
1964/65	82,045
1969/70	134,959
1974/75	154,580
1979/80	286,343
1984/85	342,113
1985/86	343,777
1986/87	349,609
1987/88	356,187
1988/89	366,354
1989/90	386,851
1990/91	407,529
1991/92	419,585
1992/93	438,618
1993/94	449,749
1994/95	452,635
1995/96	453,787
1996/97	457,984
1997/98	481,280
1998/99	490,933
1999/00	514,723
2000/01	547,867
2001/02	582,996
2002/03	586,323
2003/04	572,509
2004/05	565,039
2005/06	564,766
_EOT_

$text4 = <<_EOT_
1993	1.37611756624659
1994	1.40011622703723
1995	2.36282361531728
1996	2.66572212881711
1997	2.03703390275906
1998	2.03949398172229
1999	1.83947567046553
2000	1.66816990086047
2001	1.59447486694117
2002	1.57836474918156
2003	0.870635671656682
2004	0.371469409340142
2005	-0.159185924699553
_EOT_

class TestYAxis < Test::Unit::TestCase
  def setup
    series = Dataset::Series.new
    series.add([2000,100], [2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157])
    @dataset = Dataset::Dataset.new(:title => "Test Data")
    @dataset.add(series)

    @chart = Chart::Chart.new(:dataset => @dataset)
  end

  def make_axis(series)
    dataset = Dataset::Dataset.new
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset)
    chart.build
    chart.yaxis
  end
  
  def test_yvals
    axis = @chart.build.yaxis #Chart::YAxis.new(:chart => @chart, :data => )
    # assert_equal(Dataset::Measure::Units, axis.measure)
    assert_equal(6, axis.yvals.size)
    assert_equal(100, axis.yvals.min)
    assert_equal(157, axis.yvals.max)
    assert_equal(157, axis.max)
    assert_equal(0, axis.min) # Y axis includes zero by default
    assert_equal(0, axis.bottom)
    assert_equal(160, axis.top)
    assert_equal(9, axis.nticks)
    assert_equal(20, axis.interval_size)
    assert_equal("0", axis.ticks[0].label)
  end

  # def test_render
  #   axis = Chart::YAxis.new(@chart)
  #   renderer = Chart::Renderer.new(:indent => 2, :theme => Chart::Theme::Default.new)
  #   renderer.render(axis)
  #   # File.new("out.svg", "w") << renderer.target!
  #   xmldoc = REXML::Document.new(renderer.target!)
  #   assert_not_nil(xmldoc)
  #   assert_not_nil(xmldoc.root)
  #   axisg = xmldoc.root.elements["g[@id='yaxis']"]
  #   assert_not_nil(axisg)
  #   assert_not_nil(axisg.elements["line"])
  #   yticksg = axisg.elements["g"]
  #   assert_equal("yticks", yticksg.attributes["id"])
  #   assert_equal(9, yticksg.get_elements("line").size)
  # end

  # def test_adjust_y
  #   axis = Chart::YAxis.new(@chart)
  #   renderer = Chart::Renderer.new(:indent => 2, :theme => Chart::Theme::Default.new)
  #   assert_equal(-(100-0)*renderer.theme.data_area[:height]/160, axis.adjust_y(100, renderer))
  # end

  def test_negative_axis
    series = Dataset::Series.new
    series.add([1993, 71500  ], [1994, 145741 ], [1995, 23398  ], [1996, -10064 ])
    dataset = Dataset::Dataset.new(:title => "Negatives")
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset)
    axis = chart.build.yaxis #Chart::YAxis.new(chart)
    assert_equal(20000, axis.interval_size)
    assert_equal(-20000, axis.bottom)
    assert_equal(160000, axis.top)
  end

  def test_percentages
    # series = Dataset::Series.new(:measure => Dataset::Measure::PercentageChange)
    series = Dataset::Series.new(:measure => Dataset::Measure.new(:units => Dataset::Units::Percentage, :delta => true))
    series.measure.name = "Percent Change in Stuff"
    series.add([1993, 3 ], [1994, 12 ], [1995, 8 ], [1996, 15])
    dataset = Dataset::Dataset.new(:title => "Percentages")
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset)
    axis = chart.build.yaxis #Chart::YAxis.new(chart)
    assert_equal("0%", axis.ticks.first.label)
    assert_equal("+16%", axis.ticks.last.label)

    d1 = Dataset::Dataset.new(:source => Dataset::Source.new(:text => $text4))
    d1.series[0].measure.units = Dataset::Units::Percentage
    axis = Chart::Chart.new(:dataset => d1).build.yaxis
    assert_equal("-0.5%", axis.ticks.first.label)
    assert_equal("3.0%", axis.ticks.last.label)
  end

  def test_dollars
    series = Dataset::Series.new(:measure => Dataset::Measure.new(:units => Dataset::Units::Dollars))
    series.add([1993, 0.75  ], [1994, 1.50 ], [1995, 2.25 ], [1996, 2.65])
    dataset = Dataset::Dataset.new(:title => "Percentages")
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset)
    axis = chart.build.yaxis #Chart::YAxis.new(chart)
    assert_equal("$0.00", axis.ticks.first.label)
    assert_equal("$3.00", axis.ticks.last.label)
  end

  def test_should_stop_at_1_40
    series = Dataset::Series.new(
      :chron => Dataset::Chron::YYYYMM,
      :measure => Dataset::Measure.new(:units => Dataset::Units::Dollars))
    series.add(
      ["2006.01", 1.2118],["2006.02", 1.1875],["2006.03", 1.2104],["2006.04", 1.2537],
      ["2006.05", 1.2868],["2006.06", 1.2713],["2006.07", 1.2767],["2006.08", 1.2851],["2006.09", 1.2660])
    axis = make_axis(series)
    assert_in_delta(1.40, axis.top, 0.0001)
    assert_equal(1.40, axis.ticks.last.position)
  end

  def test_label_multipliers
    source = Dataset::Source.new(:text => $text1)
    parser = Dataset::Parser.new(:source => source)
    parser.columns[2].label = "Amount"
    data, results = parser.commit
    series = data.make_series(:measure => data.measures.first.name)
    series.measure.units = Dataset::Units::Dollars
    series.measure.multiplier = :billion
    d1 = Dataset::Dataset.new
    d1.add(series)
#     d1 = Dataset::Dataset.new(:source => Dataset::Source.new(:text => $text1))
    # d1.source.parser.measures[0].units = Dataset::Units::Dollars
    # d1.series = d1.source.parser.make_series(:multiplier => "billion")
    chart = Chart::Chart.new(:dataset => d1).build
    axis = chart.yaxis
    # assert_equal("$12,000", axis.ticks.last.label)
    assert_equal("12,000", axis.ticks.last.label)
#     assert_match(/\(in billions\)/, chart.canvas.title)
  end

  # def test_diffs
  #   d1 = Dataset::Dataset.new(:source => Dataset::Source.new(:text => $text2))
  #   d2 = d1.diffs
  #   axis = Chart::Chart.new(:dataset => d2).build.yaxis
  #   assert_equal("-100", axis.ticks.first.label)  # check that "+-" bug is fixed
  # end

  def test_percentage_labels
    d1 = Dataset::Dataset.new(:source => Dataset::Source.new(:text => $text4))
    d1.series[0].measure.units = Dataset::Units::Percentage
    axis = Chart::Chart.new(:dataset => d1).build.yaxis
  end

end
