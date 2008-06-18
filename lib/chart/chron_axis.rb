# chron axis should: collect all the chrons, sort them
#
# ASSUMPTIONS
#
# trust that all the source data (all series.data elements) have the same Chron
#
# CONSIDERATIONS
# axis width should not extend beyond the data range; this is not true for Y axis
# means that bottom and top should = min and max
#
# need to know the interval between measure values
#
# TODO: for chart with lots of chrons, figure out what ticks to show
# TODO: scan for hard-coded values; maybe a default theme with all those settings
#


module Chart
  class ChronAxis
    attr_reader :min, :max, :bottom, :top, :chrons
    attr_reader :ticks, :line, :legend, :chron
    attr_reader :interval_size

    def initialize(args)
      @chart = args[:chart]
      @data = args[:data]
      build(@chart)
    end

    def build(chart)
      @chron = chart.tablespec.chron
      @interval_size = @chron.interval.to_f
      @maximum_intervals = chart.theme.chronaxis.maxticks || 20 # TODO - should be a computed value

      add_data(@data) #chart.tablespec.chron_column.min, chart.tablespec.chron_column.max)
      # chart.dataset.series.each { |series| add_data(series.data.map {|e| e[:chron]}.select {|c| c.value >= chart.constraints[:from].value && c.value <= chart.constraints[:to].value }) }
    end

    def add_data(*ary)
      @chrons ||= []
      @chrons += ary.flatten
      @chrons.sort! { |a, b| a.value <=> b.value }.uniq!
      @min = @chrons.first
      @max = @chrons.last
      @bottom = @min.value - interval_size/2
      @top = @max.value + interval_size/2
      calculate
    end

    def length
      # top.value - bottom.value
      # top - bottom
      position_x(top) - position_x(bottom)
    end

    def calculate
      compute_positions
      compute_ticks
    end

    def compute_positions
      @positions = @chrons.map { |c| position(c) }
    end

    # this is really sketchy logic, trusting that there aren't too many entries
    # in the source data, and no gaps in the chron sequence
    #
    # even if chrons.size < @maximum_intervals, we might not want to show them all,
    # if there are gaps in the sequence.
    def compute_ticks
      smallest_interval = chrons.map {|c| c.value}.diffs.min
      nintervals = (top - bottom)/smallest_interval
      interval = smallest_interval
      while (nintervals > @maximum_intervals)
        interval = chron.next_interval_after(interval)
        nintervals = (top - bottom)/interval
      end

      if chron == Dataset::Chron::YYYYMM && interval >= 1.0
        @chron = Dataset::Chron::YYYY
      end

      tick_values = []
      x = chrons.first.value.round_down(interval)
      while x <= chrons.last.value.round_up(interval) do
        tick_values << x
        x += interval
      end
      tickChrons = tick_values.map do |tv|
        # TODO: clean this up, it's an ugly hack to workaround SchoolYear not having
        # a numeric constructor; there must be a cleaner way to do the initialization
        # stuff in chron.rb
        if chron == Dataset::Chron::SchoolYear
          chron.new(:yyyy => tv)
        else
          chron.new(tv)
        end
#         chron.new(tv)
      end

      # adjust the axis so that the first tick is inside the axis
      if tick_values.first < @bottom
        @bottom = tick_values.first - interval_size/2
      end

      # adjust the axis so that it extends all the way to the final tick label
      @top = tick_values.last + interval_size/2

      # if chron != Dataset::Chron::YYYY then
      #   @ticks = chrons.map {|chron| Tick.new(self, chron)}
      # else
      #   if chrons.size <= @maximum_intervals then
      #     @ticks = chrons.map {|chron| Tick.new(self, chron)}
      #   else
      #     first_tick = chrons.first.value.round_up(5)
      #     last_tick = chrons.last.value.round_down(5)
      #     tickChrons = []
      #     (first_tick .. last_tick).step(5) do |n|
      #       tickChrons << chron.new(n)
      #     end
          @ticks = tickChrons.map {|chron| Tick.new(self, chron)}
        # end
      # end
    end

    def position(aChron)
      # assume aChron.instance_of?(self.chron)
      # (aChron.value - bottom)/interval_size
      position_x(aChron.value)
    end

    def position_x(x)
      (x - bottom) / interval_size
    end

    def adjust_x(x, r)
      # (x - self.bottom) * r.theme.data_area[:width] / self.length
      position_x(x) * r.theme.data_area[:width] / self.length
      # ((x - self.bottom.value) + interval_size/2) * r.theme.data_area[:width] / (self.length + interval_size)
    end

    def adjust_chron(aChron, r)
      position(aChron) * r.theme.data_area[:width] / self.length
    end

    def render_axis_line(r)
      y = 0
      if chart.yaxis.bottom > 0 then
        y = chart.yaxis.bottom
      end
      r.line(
        :x1 => 0,
        :y1 => chart.adjust_y(y, r),
        :x2 => r.theme.data_area[:width],
        :y2 => chart.adjust_y(y, r),
        :id => "xaxisline"
      )
    end

    def render(r)
      r.g(:id => "chron_axis") do
        render_axis_line(r)
        r.g(:id => "xticks") do
          render_ticks(r)
        end
      end
    end

    def render_ticks(r)
      if chron == Dataset::Chron::YYYYMM then
        # TODO: move this into a subclass
        # TODO: if there's just one year in the input, only need one row of labels
        years = ticks.map {|tick| tick.chron.year}.uniq
        ypos = r.theme.axes[:tick_length] + r.theme.axes[:font_size]
        if ticks.size < @maximum_intervals * 3 then
          ticks.each do |tick|
            r.text(tick.chron.m,
                   :x => adjust_chron(tick.chron, r),
                   :y => ypos,
                   'text-anchor' => 'middle'
                   )
          end
          # we drew a row of tick labels; move down for another row of labels
          ypos = (r.theme.axes[:tick_length] + r.theme.axes[:font_size]) * 2
        end

        # next row of labels: years
        years.uniq.sort.each do |year|
          r.text(year,
                :x => adjust_x(year + 0.5, r),
                :y => ypos,
                'text-anchor' => 'middle'
                )
        end
      else
        ticks.each do |tick|
          tick.render(r)
        end
      end
    end


    # on a Chron axis, the Ticks must themselves be Chrons, NOT just numbers

    class Tick < Struct.new(:axis, :chron)
      def initialize(*args)
        super
      end

      def render(r)
        # render_tick(r)
        render_label(r)
      end

      def render_tick(r)
        # puts "X tick #{position}"

        # r.line(:x1 => axis.adjust_x(position, r), #(position - axis.bottom) * r.theme.data_area[:width] / axis.length,
        #        :y1 => 0,
        #        :x2 => axis.adjust_x(position, r), # - axis.bottom) * r.theme.data_area[:width] / axis.length,
        #        :y2 => r.theme.axes[:tick_length],
        #        :class => "xtick")
      end

      def render_label(r)
        if chron.instance_of?(Dataset::Chron::YYYYMM) then
          r.text(chron.m,
                 :x => axis.adjust_chron(chron, r),
                 :y => r.theme.axes[:tick_length] + r.theme.axes[:font_size],
                 'text-anchor' => 'middle'
                 )
          # yuck, this will overwrite the year multiple times, once for each month
          r.text(chron.year,
                :x => axis.adjust_x(chron.year + 0.5, r),
                :y => (r.theme.axes[:tick_length] + r.theme.axes[:font_size]) * 2,
                'text-anchor' => 'middle'
                )
        else
          r.text(chron.to_s,
                 :x => axis.adjust_chron(chron, r),
                 :y => r.theme.axes[:tick_length] + r.theme.axes[:font_size],
                 'text-anchor' => 'middle'
                 )
        end
      end
    end
  end
end

class Integer
  def round_up(interval)
    if self % interval == 0 then
      self
    else
      ((self / interval) + 1) * interval
    end
  end
  def round_down(interval)
    (self / interval) * interval
  end
end

class Array
  def diffs
    b = []
    self.inject do |prev,succ|
      b << succ-prev
      succ
    end
    b
  end
end
