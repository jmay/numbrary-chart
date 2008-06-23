require File.dirname(__FILE__) + '/spec_helper'

describe "layer constructed from tablespec" do
  before(:all) do
    @tablespec = YAML.load(testdata('annual_data.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/annual_data.nsf') # source has shuffled chron order
    @chart = Chart::Chart.new(:tablespec => @tablespec)
    @layer = Chart::Layer::Line.new(:chart => @chart)
  end

  it "should have a point for every data value" do
    @layer.points.size.should == 6
  end

  it "should represent points as (chron, numeric)" do
    @layer.points.each do |pt|
      pt.size.should == 2
      pt[0].should be_instance_of(Dataset::Chron::YYYY)
      pt[1].should be_kind_of(Numeric)
    end
  end

  it "should sort points in chron order" do
    @layer.points.map {|pt| pt[0].value}.should == [2000, 2001, 2002, 2003, 2004, 2005]
  end
end
