#!/usr/bin/env ruby

require "chart"
require "chart/chart2"

datafile = ARGV.shift
metafile = ARGV.shift

table = YAML.load_file(metafile)

chart = Chart::Chart2.new(:table => table)
puts chart.to_yaml
