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
  end
end
