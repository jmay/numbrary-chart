#!/usr/bin/env ruby

require "libdataset"
require "libchart"

title = ARGV.shift || "Test Data"

records = []
while gets
    # records << $_.chomp.gsub(/,/,"" )
    records << $_
end

parser = Dataset::Parser.new(:input => records.join)

series = Dataset::Series.new(
  :chron => parser.chron,
  :measure => parser.measure)

# build series from the first (=chron) and last (=measure) elements in each row
# records.each {|e| series.add(e.split.values_at(0,-1))}
parser.records.each {|r| series.add(r)}

@dataset = Dataset::Dataset.new(:title => title)
@dataset.add(series)
@chart = Chart::Chart.new(:dataset => @dataset, :theme => Chart::Theme::Default.new)
@chart.build
# puts @chart.xaxis.to_yaml

renderer = Chart::Renderer.new(:theme => @chart.theme, :indent => 2)
renderer.render(@chart)
STDOUT << renderer.target!
# File.new("out.svg", "w") << renderer.target!
