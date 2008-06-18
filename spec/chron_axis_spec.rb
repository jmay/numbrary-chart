require File.dirname(__FILE__) + '/spec_helper'

describe Chart::ChronAxis, "should support new tablespec structure" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tabledata = @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf')
    @chart = Chart::Chart.new(
      :tablespec => @tablespec,
      :data => @tabledata
    )
  end

  it "should build axis" do
    axis = Chart::ChronAxis.new(:chart => @chart, :data => @tablespec.chrondata)
    axis.min.value.should == 2000
    axis.max.value.should == 2005
    axis.bottom.should == 1999.5
    axis.top.should == 2005.5
    axis.length.should == 6
    axis.interval_size.should == 1
  end
end
