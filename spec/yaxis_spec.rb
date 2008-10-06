require File.dirname(__FILE__) + '/spec_helper'

describe Chart::YAxis, "should support new tablespec structure" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)
  end

  it "should build axis" do
    axis = Chart::YAxis.new(:chart => @chart, :data => @tablespec.measuredata)
    axis.min.should == 0.0
    axis.max.should == 157.0
    axis.bottom.should == 0
    axis.top.should == 160
    axis.length.should == 160
    axis.interval_size.should == 20
    axis.ticks.map(&:label).should == ["$0", "$20", "$40", "$60", "$80", "$100", "$120", "$140", "$160"]
  end
end

describe "Y Axis in percent" do
  it "percentage axis ticks should be labelled with single decimal" do
    @tablespec = YAML.load(testdata('percent_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/percent_data.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)

    axis = Chart::YAxis.new(:chart => @chart, :data => @tablespec.measuredata)
    axis.ticks.map(&:label).should == ["-1.5%", "-1.0%", "-0.5%", "0.0%", "0.5%", "1.0%", "1.5%", "2.0%"]
    # this is what I really want
    # axis.ticks.map(&:label).should == ["-1.5%", "-1.0%", "-0.5%", "0%", "+0.5%", "+1.0%", "+1.5%", "+2.0%"]
  end

  it "percentage axis ticks should be labelled with no sign on Y=0" do
    @tablespec = YAML.load(testdata('percent_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/percent_data2.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)

    axis = Chart::YAxis.new(:chart => @chart, :data => @tablespec.measuredata)
    axis.ticks.map(&:label).should == ["-0.3%", "-0.2%", "-0.1%", "0.0%", "0.1%", "0.2%", "0.3%", "0.4%", "0.5%"]
  end
end
