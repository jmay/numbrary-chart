require File.dirname(__FILE__) + '/test_helper'

class TestChronAxis < Test::Unit::TestCase

  # Foreign Enrollment dataset from http://opendoors.iienetwork.org/?p=89192
  @@text1 = <<_EOT_
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

  @@text2 = <<EOT
1965          2.75        88.414   
1966          2.75        88.414   
1967          2.75        88.414   
1968          2.50        80.377   
1970          2.50        80.377   
1970          2.50        80.377   
1971          2.50        80.377   
1972          2.50        80.377   
1973          1.77        56.907   
1974          4.42       142.106   
EOT

  def testdata(name)
    File.open(File.dirname(__FILE__) + "/testdata/#{name}").read
  end

  def test_years
    series = Dataset::Series.new
    series.add([2000,100], [2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157])
    dataset = Dataset::Dataset.new(:title => "Test Data")
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset)
    chart.build
    axis = chart.chron_axis
    assert_equal(6, axis.chrons.size)
    assert_equal(2000, axis.min.value)
    assert_equal(2005, axis.max.value)
    assert_equal(1999.5, axis.bottom)
    assert_equal(2005.5, axis.top)
    assert_equal(6.0, axis.length)
    assert_equal(1, axis.interval_size)

    # renderer = Chart::Renderer.new(:indent => 2, :theme => Chart::Theme::Default.new)
    # assert_equal(0.5 * renderer.theme.data_area[:width] / axis.length, axis.adjust_chron(axis.chron.new(2000), renderer))
  end

  def test_ticks
    long_series = Dataset::Series.new
    ary = (1950..2000).map {|n| [ n, n-1900 ]}
    long_series.add(*ary)
    dataset = Dataset::Dataset.new(:title => "Test Data").add(long_series)
    chart = Chart::Chart.new(:dataset => dataset)
    chart.build
    axis = chart.chron_axis
    assert_equal(11, axis.ticks.size)
    assert_equal(1949.5, axis.bottom)
    assert_equal(2000.5, axis.top)
  end

  def test_months
    series = Dataset::Series.new(:chron => Dataset::Chron::YYYYMM)
    series.add(["200004", 100], ["200005", 101], ["200006", 120], ["200007", 140], ["200008", 130], ["200009", 157],
    ["200010", 200], ["200011", 300], ["200012", 400], ["200101", 500])
    dataset = Dataset::Dataset.new.add(series)
    chart = Chart::Chart.new(:dataset => dataset).build
    axis = chart.chron_axis
    # renderer = Chart::Renderer.new(:theme => chart.theme, :indent => 2)
    # renderer.render(chart)
    # xmldoc = REXML::Document.new(renderer.target!)
    # # puts xmldoc
    # # puts xmldoc.root.elements["g[@id='data']"].elements["g[@id='chron_axis']"]
    # ticks = xmldoc.root.elements["g[@id='data']"].elements["g[@id='chron_axis']"].elements["g[@id='xticks']"]
    # check coordinates via ticks.elements[1].attributes["x"]
    assert(axis.bottom < axis.ticks.first.chron.value)
    assert_equal(2000 + 2.5/12, axis.bottom)
    assert_equal(0, axis.position_x(axis.bottom))
    assert_in_delta(3.5, axis.position_x(2000 + 0.5), 2 ** -20)
  end

  def test_constraints
    series = Dataset::Series.new
    series.add([2000,100], [2001,101], [2002, 120], [2003, 140], [2004, 130], [2005, 157])
    assert(! series.gaps?)
    dataset = Dataset::Dataset.new(:title => "Test Data")
    dataset.add(series)
    chart = Chart::Chart.new(:dataset => dataset, :constraints => {:from => series.chron.new(2003)})
    chart.build
    axis = chart.chron_axis
    assert_equal(2003, axis.min.value)
  end

  def test_gaps
    d1 = Dataset::Dataset.new(:source => Dataset::Source.new(:text => @@text1))
    assert(d1.series[0].gaps?)
    chart = Chart::Chart.new(:dataset => d1).build
    axis = chart.chron_axis
    assert_equal("54-55", axis.ticks.first.chron.to_s)
    assert_equal("09-10", axis.ticks.last.chron.to_s)
    d2 = d1.diffs
    # p d1.series[0].data.map {|e| e[:chron]}
    # p d2.series[0].data.map {|e| e[:chron]}
    c2 = Chart::Chart.new(:dataset => d2).build
    
    axis2 = c2.chron_axis
  end

  # # text2 sample contains a duplicate row (input error)
  # def test_should_handle_dup_chrons
  #   assert_raise(RuntimeError) { Dataset::Dataset.new(:source => Dataset::Source.new(:text => @@text2).parse) }
  #   # chart = Chart::Chart.new(:dataset => d1).build
  #   # axis = chart.chron_axis
  # end

  def test_limit_axis_ticks
    dataset = Dataset::Dataset.new(:source => Dataset::Source.new(:text => testdata("manu_orders.csv")))
    puts dataset.series.map{|ser| ser.chron}
    chart = Chart::Chart.new(:dataset => dataset).build
    ticks = chart.chron_axis.ticks
    assert(ticks.size <= chart.theme.chronaxis.maxticks)
    assert(ticks.first.chron.value <= dataset.series.first.data.first[:chron].value)
    assert(ticks.last.chron.value >= dataset.series.first.data.last[:chron].value)
    assert(chart.chron_axis.bottom <= ticks.first.chron.value)
    assert(chart.chron_axis.top >= ticks.last.chron.value)
    assert_equal("1992", ticks.first.chron.to_s)
    assert_equal("2008", ticks.last.chron.to_s)
  end

  def test_quarters
    dataset = Dataset::Dataset.new(:source => Dataset::Source.new(:text => testdata("quarterly_data.csv")))
    chart = Chart::Chart.new(:dataset => dataset).build
    axis = chart.chron_axis
    assert axis.bottom < axis.min.value
    assert axis.top > axis.max.value
  end
end
