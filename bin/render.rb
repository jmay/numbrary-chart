#!/usr/bin/env ruby

require "chart"
require "chart/chart2"
require "chart/render/rplot"

chartfile = ARGV.shift

chart = YAML.load_file(chartfile)

rplot = Chart::RPlotRenderer.new(chart)
output = rplot.render
puts output
