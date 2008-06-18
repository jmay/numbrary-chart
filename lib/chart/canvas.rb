module Chart
  class Canvas
    def initialize(args)
      @chart = args[:chart]
      build
    end

    # compute:
    # * chart title
    # * aspect ratio
    # * margins between plot region and chart region
    # * TODO: legend (maybe)
    def build
      title
    end

    def title
      title = "TODO: where to get title from?"
      if @chart.yaxis && @chart.yaxis.scale then
        title += " (in #{@chart.yaxis.scale}s)"
      end
    end
  end
end
