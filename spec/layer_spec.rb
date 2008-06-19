require File.dirname(__FILE__) + '/spec_helper'

describe Chart::Layer::Line, "should support new tablespec structure" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)
  end

  it "should build layer" do
    layer = Chart::Layer::Line.new(:chart => @chart)
    layer.points.size.should == 6
    layer.points.map {|pt| pt[0]}.each {|pt| pt.should be_instance_of(Dataset::Chron::YYYY)}
    layer.points.map {|pt| pt[1]}.each {|pt| pt.should be_kind_of(Numeric)}
  end
end
