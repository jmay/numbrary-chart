require File.dirname(__FILE__) + '/spec_helper'

describe Chart::Chart, "should support new tablespec structure" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)
  end

  it "should build layer" do
    @chart.build
    @chart.chron_axis.should_not be_nil
    @chart.yaxis.should_not be_nil
    @chart.layers.size.should == 1
  end
end
