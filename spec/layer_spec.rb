require File.dirname(__FILE__) + '/spec_helper'

describe Chart::Layer::Line, "should support new tablespec structure" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tabledata = @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf')
    @chart = Chart::Chart.new(
      :tablespec => @tablespec,
      :data => @tabledata
    )
  end

  it "should build layer" do
    layer = Chart::Layer::Line.new(:chart => @chart, :data => @tablespec.measuredata)
  end
end
