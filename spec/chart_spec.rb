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

describe "multi-line chart" do
  it "should build two layers" do
    @tablespec = YAML.load(testdata('two_measures.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/two_measures.nsf') #, :skip_number_formatting => true)
    @chart = Chart::Chart.new(:tablespec => @tablespec)
    @chart.build
    @chart.chron_axis.should_not be_nil
    @chart.yaxis.should_not be_nil
    @chart.layers.size.should == 2
  end
end
