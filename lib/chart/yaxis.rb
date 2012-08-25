# DOES NOT SUPPORT:
#    Series with different measures, that needs multiple Y axes.
#
# This is a chart vertical axis that represents a single measure.
#

# require "axis"

require "bigdecimal"

module Chart
  class YAxis < Axis
    attr_reader :ticks, :line, :legend, :yvals, :measure, :chart

    def initialize(args)
      @chart = args[:chart]
      @data = args[:data]
      if @chart.tablespec
        @measure = @chart.tablespec.measure
        super(@data)
      end
      if @chart.dataset
        @measure = @chart.dataset.series.first.measure

        @yvals = []
        # chart.dataset.series[0].data.each { |e| @yvals << e[:measure].value if e[:chron] >= chart.constraints[:from] }
        chart.dataset.series[0].data.each { |e| @yvals << e[:measure] } #if e[:chron] >= chart.constraints[:from] && e[:chron] <= chart.constraints[:to] }
        # @yvals = chart.dataset.series.collect { |series| series.data.map { |e| e[:measure].value } }.flatten.sort.uniq
        super(@yvals)
      end
      include_zero #unless @measure.rate?

      self.maximum_intervals = chart.theme.yaxis.maxticks

      compute_ticks
      # add_data(@yvals)
    end

    def decide_label_format
      @format_units = @measure.units
      @format_units = @format_units.dup
      @format_units.options ||= {}

      # figure out the needed number of decimals based on the values themselves
      interval = length.to_f / (@tick_positions.size - 1)
      if interval.to_s =~ /\.0+$/
        @format_units.options[:decimals] = 0
      else
        @format_units.options[:decimals] = 1
      end

      # TODO: for the special case of Y=0, probably don't want to show decimals, even if rest of ticks have them
      # TODO: for "change in X" measures, should put a + before positive values
    end

    def decide_label_format_old
      @format_hints = {}
      if @measure.change? then
        @format_hints[:sign] = true
      end
      if @measure.units == Dataset::Units::Percentage then
        # figure out whether to show decimals or not
        # this is really ugly; there has to be a better way
#         if @tick_positions.find_all { |tick| ((tick*10000).floor.to_f/100 - (tick*100).floor).nonzero? }.empty? then
        if @tick_positions.find_all { |tick| ((tick*100).floor.to_f/100 - tick.floor).nonzero? }.empty? then
          @format_hints[:decimals] = 0
        end
      end
      tick_label_reductions
    #   if @measure.units.continuous? then
    #     max = chart.dataset.series[0].max_measure.value.abs
    #     puts "max is #{max}"
    #     case
    #     when max < 1.0: decimals = 3
    #     when max < 2.0: decimals = 2
    #     when max < 3.0: decimals = 1
    #     else decimals = 0
    #     end
    #     @format_hints[:decimals] = decimals
    #     p @format_hints
    #   end
    end

    def tick_label_reductions
      if top > 1.billion
        @format_hints[:divide_by] = :billion
        @format_hints[:decimals] = 0
      elsif top > 1.million
        @format_hints[:divide_by] = :million
        @format_hints[:decimals] = 0
      elsif top > 100
        @format_hints[:decimals] = 0
      end
    end

    def scale
      @format_hints[:divide_by]
    end

    def compute_ticks
      @tick_positions = []
      bottom.upto(top, :by => interval_size) {|tick| @tick_positions << tick}
      decide_label_format
      @ticks = []
      # bottom.upto(top, :by => interval_size) {|tick| @ticks << Tick.new(self, tick, @measure.format(tick, @format_hints))}
      bottom.upto(top, :by => interval_size) {|tick| @ticks << Tick.new(self, tick, @format_units.new(tick).to_s)}
      # bottom.upto(top, :by => interval_size) {|tick| @ticks << Tick.new(self, tick, @measure.units.new(tick, @format_hints).to_s)}
    end

    def scale_vertical(v, r)
      v * r.theme.data_area[:height] / self.length
    end

    def adjust_y(y, r)
      -(y - self.bottom) * r.theme.data_area[:height] / self.length
      # -y * r.theme.data_area[:height] / self.length
      # (x - self.bottom) * r.theme.data_area[:width] / self.length
    end

    def render_axis_line(r)
      r.line(:x1 => 0, :y1 => 0, :x2 => 0, :y2 => -r.theme.data_area[:height], :id => "yaxisline")
    end

    def render(r)
      r.g(:id => "yaxis") do
        render_axis_line(r)
        if chart.dataset.baseline? then
          render_baseline(r)
        end
        r.g(:id => "yticks") do
          ticks.each do |tick|
            tick.render(r)
          end
        end
      end
    end

    # draw a horizontal baseline at Y=100% - but only for baseline charts
    def render_baseline(r)
      r.line(
        :id => "baseline",
        :x1 => 0,
        :y1 => adjust_y(1.0, r),
        :x2 => r.theme.data_area[:width],
        :y2 => adjust_y(1.0, r)
      )
    end

  end

  class Tick < Struct.new(:axis, :position, :label)
    def initialize(*args)
      super
    end

    def render(r)
      # tick outside the axis
      r.line(:x1 => 0,
             :y1 => axis.adjust_y(position, r), #-(position - axis.bottom) * r.theme.data_area[:height] / axis.length,
             :x2 => -r.theme.axes[:tick_length],
             :y2 => axis.adjust_y(position, r), #-(position - axis.bottom) * r.theme.data_area[:height] / axis.length,
             :class => "ytick")

      # gridline inside the data area
      # r.line(:x1 => 0,
      #        :y1 => axis.adjust_y(position, r), #-(position - axis.bottom) * r.theme.data_area[:height] / axis.length,
      #        :x2 => r.theme.data_area[:width],
      #        :y2 => axis.adjust_y(position, r), #-(position - axis.bottom) * r.theme.data_area[:height] / axis.length,
      #        :class => "ytick")

      r.text(label,
             :x => -r.theme.axes[:tick_length] * 2,
             :y => axis.adjust_y(position, r) + r.theme.axes[:font_size]/2,
             'text-anchor' => 'end'
             )
    end
  end

end
