module Chart
  class Chart
    attr_reader :tablespec, :theme
    attr_reader :canvas, :chron_axis, :yaxis, :layers

    def initialize(args)
      @tablespec = args[:tablespec]
      @theme = args[:theme] || Theme::Default.new
    end

    def build
      @canvas = Canvas.new(:chart => self)

      if @tablespec.chron?
        @chron_axis = ChronAxis.new(:chart => self, :data => @tablespec.chrondata)
      end

      @layers = []
      if @tablespec.measure?
        @yaxis = YAxis.new(:chart => self, :data => @tablespec.measuredata)
        @layers << Layer::Line.new(:chart => self, :series => @tablespec.measuredata)
      end

      # TODO: multiple layers

      self
    end
  end
end


# module Chart
#   class Chart
#     attr_reader :dataset, :theme, :constraints
#     attr_reader :xaxis, :yaxis, :canvas, :layers
#     attr_reader :chron_axis
# 
#     def initialize(args)
#       @dataset = args[:dataset]
#       @theme = args[:theme] || Theme::Default.new
#       @constraints = args[:constraints] || {}
#     end
# 
#     def configure
#       @constraints[:from] ||= @dataset.series[0].chrons.min
#       @constraints[:to] ||= @dataset.series[0].chrons.max
#       @layers = []
#     end
# 
#     def build
#       configure
# 
#       @canvas = Canvas.new(self)
#       @chron_axis = ChronAxis.new(self)
#       @yaxis = YAxis.new(self)
# 
#       @dataset.series.each do |series|
#         @layers << style_for(series).new(:chart => self, :series => series)
#       end
# 
#       self
#     end
# 
#     def adjust_x(x, r)
#       self.chron_axis.adjust_x(x, r)
#     end
# 
#     def scale_vertical(v, r)
#       self.yaxis.scale_vertical(v, r)
#     end
# 
#     def adjust_y(y, r)
#       self.yaxis.adjust_y(y, r)
#     end
# 
#     def render(r)
#       canvas.render(r)
#       x_offset = (theme.canvas[:width] - theme.data_area[:width])/2
#       y_offset = (theme.canvas[:height] - theme.data_area[:height])/2
#       # y_offset is where the yaxis.bottom should be, so figure out where yaxis=0 would be
#       # theme.data_area[:height]
#       r.g(:transform => "translate(#{theme.canvas[:width] * theme.canvas[:margin]}, #{theme.canvas[:height] * (1 - theme.canvas[:margin])})",
#           :id => "data") {
#         yaxis.render(r)
#         layers.each {|layer| layer.render(r)}
#         chron_axis.render(r)
#       }
#     end
# 
#     def style_for(series)
#       Layers::Line
# 
#       # if series.measure.change? then
#       #   return Layers::Line
#       # end
#       # 
#       # # if series.measure.rate? then
#       # #   return Layers::Line
#       # # end
#       # 
#       # if series.data.size > 20 then
#       #   return Layers::Line
#       # end
#       # 
#       # if series.gaps? then
#       #   return Layers::Line
#       # end
#       # 
#       # Layers::Bar
#     end
#   end
# end
