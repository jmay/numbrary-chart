module Chart
  class Layer
    attr_reader :chart, :series
    # attr_reader :elements

    def initialize(args)
      @chart = args[:chart]
      # @data = args[:data]
    end
  end

  class Layer::Bar < Layer
    attr_reader :bars

    def initialize(params)
      super
      @bars = []
      series.data.each { |e| @bars << Bar.new(chart, e, series.measure) if e[:chron] >= chart.constraints[:from] && e[:chron] <= chart.constraints[:to] }
    end

    def render(r)
      r.g(:class => "layer") do
        bars.each {|bar| bar.render(r)}
      end
    end
  end

  class Bar
    attr_reader :x, :y, :height, :chart

    def initialize(chart, entry, measure)
      @chart = chart
      @x = entry[:chron]
      @y = 0.0
#       @height = entry[:measure].value
      @height = entry[:measure]
#       @gap = measure.event? ? 0 : 0.5
      @gap = 0.5
    end
    
    def render(r)
      # puts "Bar at #{x}, #{y}, h = #{height} on #{chart.xaxis.bottom}, #{chart.yaxis.bottom}"
      bar_footprint = chart.adjust_x(x.next.value, r) - chart.adjust_x(x.value, r)
      # if gap = 1.0, then bar width = footprint/2
      # if gap = 2.0, then bar width = footprint/3
      # if gap = 0.0, then bar width = footprint
      # if gap = 0.5, then bar width = footprint * 2/3
      # footprint = bar_width * (1 + gap)
      # bar_width = footprint / (1 + gap)
      # bar_width = bar_footprint / (1 + r.theme.bars[:gap])
      # bar_width = bar_footprint / (1 + r.theme.bar_gap)
      bar_width = bar_footprint / (1 + @gap)

      if height < 0 then
        bar_y = 0
        bar_height = -height
      else
        bar_y = height
        bar_height = height
      end

      r.rect(:x => (chart.adjust_x(x.value, r) - (bar_width/2)).round, #(x - chart.xaxis.bottom) * r.theme.data_area[:width] / chart.xaxis.length,
             :y => (chart.adjust_y(bar_y, r)).round, #-(height - chart.yaxis.bottom) * r.theme.data_area[:height] / chart.yaxis.length,
             :width => bar_width.ceil,
             :height => chart.scale_vertical(bar_height, r).round #(height - chart.yaxis.bottom) * r.theme.data_area[:height] / chart.yaxis.length,
             # :style => "fill: red; stroke: none;")
             )
    end
  end

  class Layer::Line < Layer
    attr_reader :points, :chart

    def initialize(args)
      super

      chron_colnum = chart.tablespec.chron_column.colnum
      measure_colnum = chart.tablespec.measure_column.colnum
      @points = chart.tablespec.rows.map {|row| row.values_at(chron_colnum, measure_colnum)}

      # series.data.each { |e| @points << [ e[:chron], e[:measure] ] if e[:chron] >= chart.constraints[:from] && e[:chron] <= chart.constraints[:to] }
    end

    def render(r)
      r.g(:class => "layer line") do
        adjusted_points = points.map { |x,y| [ chart.adjust_x(x.value, r), chart.adjust_y(y.value, r) ].join(",")}
        r.polyline(:points => adjusted_points.join(" "))
      end
    end
  end

end
