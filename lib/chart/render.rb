require "builder"

module Chart; end

class Chart::Renderer < Builder::XmlMarkup
  attr_reader :theme

  def initialize(options = {})
    # options[:target] = File.new("out.svg", File::RDWR)
    super(options)
    @theme = options[:theme]
  end

  def render(*args)
    instruct!
    declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
    svg(:xmlns => "http://www.w3.org/2000/svg", 'xmlns:xlink' => "http://www.w3.org/1999/xlink",
        # no need to specify absolute dimensions here, that can come from the parent HTML,
        # just give a viewBox so that chart coordinates are all relative to that.
        # :width => "8in", :height => "4in",
        :viewBox => "0 0 #{theme.canvas[:width]} #{theme.canvas[:height]}") {
      defs {
        style(:type => "text/css") {
          cdata!(css(theme))
        }
      }
      # g(:id => "canvas") {
      #   rect(:x => 0, :y => 0, :width => "100%", :height => "100%")
      # }
      # g(:transform => "translate(#{theme.canvas[:width] * theme.canvas[:margin]}, #{theme.canvas[:height] * (1 - theme.canvas[:margin])}") {
        args.each { |obj| obj.render(self) }
      # }
    }
  end

  def css(theme)
    <<_EOT_
    #canvas rect {
      stroke: #DDDDDD;
      stroke-width: 5px;
      fill: none;
    }
    #canvas text {
      font-size: #{theme.canvas.title_font_size}px;
    }

    rect {
      fill: #336699;
      # stroke: none;
      # stroke-width: 0;
    }

    line {
      stroke: black;
      stroke-width: 0.5px;
    }

    polyline {
      fill: none;
      stroke: black;
      stroke-width: 5px;
    }

    text {
      font-family: 'Arial', sans-serif;
      font-weight: normal;
      font-style: normal;
      font-size: #{theme.axes.font_size}px;
      fill: black;
      stroke: black;
      stroke-width: 0.5px;
    }
_EOT_
  end

end


# Re-writing the output generation in XmlMarkup so that all the floats (which should be
# limited here to coordinates and lengths) are truncated to 2 decimals, to keep the output
# reasonably clean.

module Builder
  class XmlMarkup < XmlBase
    private
    # remove_method :_attr_value
    def _attr_value(value)
      case value
        when Symbol: value.to_s
        when Float: sprintf("%.2f", value)
        else _escape_quote(value.to_s)
      end
    end
  end
end
