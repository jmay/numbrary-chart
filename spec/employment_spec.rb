require File.dirname(__FILE__) + '/spec_helper'

describe "monthly employment chart" do
  before(:all) do
    @tablespec = YAML.load(testdata('employment.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/employment.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec)
    @chart.build
  end

  it "should build layer" do
    @chart.chron_axis.should_not be_nil
    @chart.yaxis.should_not be_nil
    @chart.layers.size.should == 1
  end

  it "should label chron axis in decades" do
    @chart.chron_axis.ticks.map {|tick| tick.chron.to_s}.should == ["1940", "1950", "1960", "1970", "1980", "1990", "2000", "2010"]
  end

  it "should label Y axis in 20K increments" do
    @chart.yaxis.ticks.map(&:label).should == ["0", "20,000", "40,000", "60,000", "80,000", "100,000", "120,000", "140,000", "160,000"]
  end
end


describe "monthly employment thumbnail" do
  before(:all) do
    @tablespec = YAML.load(testdata('employment.yaml'))
    @tablespec.read(File.dirname(__FILE__) + '/testdata/employment.nsf')
    @chart = Chart::Chart.new(:tablespec => @tablespec, :theme => Chart::Theme::Thumbnail.new)
    @chart.build
  end

  it "should label chron axis in decades" do
    @chart.chron_axis.ticks.map {|tick| tick.chron.to_s}.should == ["1940", "1960", "1980", "2000", "2020"]
  end

  it "should label Y axis in 40K increments" do
    @chart.yaxis.ticks.map(&:label).should == ["0", "50,000", "100,000", "150,000"]
  end
end
