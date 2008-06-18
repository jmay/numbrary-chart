module Chart
  module Theme
    Canvas = Struct.new("Canvas", :width, :height, :margin, :top_margin, :title_font_size)
    Axes = Struct.new("Axes", :tick_length, :font_size)
    Bars = Struct.new("Bars", :gap)
    DataArea = Struct.new("DataArea", :width, :height)
    ChronAxis = Struct.new("ChronAxis", :maxticks)

    class Base
      attr_accessor :canvas, :axes, :bars, :chronaxis

      def initialize
        @canvas = Canvas.new
        @axes = Axes.new
        @bars = Bars.new
        @data_area = nil
        @chronaxis = ChronAxis.new
        # @canvas = args[:canvas] || {}
        # @axes = args[:axes] || {}
        # @bars = args[:bars] || {}
      end

      def data_area
        if @data_area.nil? then
          @data_area = {
            :width => canvas.width * (1 - canvas.margin * 2),
            :height => canvas.height * (1 - canvas.margin * 2)
            }
        end
        @data_area
      end
      # def method_missing(meth, *args, &block)
      #   "style"
      # end

      def bar_gap
        0.50
      end

    end

    class Default < Base
      def initialize
        super
        canvas.width = 800
        canvas.height = 400
        canvas.margin = 0.12
        canvas.top_margin = 25
        canvas.title_font_size = 25
        axes.tick_length = 5
        axes.font_size = 10
        bars.gap = 0.0
        chronaxis.maxticks = 12
        # super(:canvas => { :width => 800, :height => 400, :margin => 0.12 },
        #       :axes => { :tick_length => 5, :font_size => 8 },
        #       :bars => { :width => 100, :gap => 0.0 })
      end
    end
  end
end

# def theme(name, &block)
#   # className = Chart::Theme::name
# end
# 
# theme "NYTimes" do
#   canvas {
#     width "400"
#     height "200"
#     margin "10%"
#   }
#   axes {
#     stroke "2px"
#     color black
#   }
#   bars {
#     width "100%"
#     color gray50
#   }
# end
