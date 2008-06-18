module Chart
  class RPlotRenderer
    def initialize(chart)
      @chart = chart
    end

    def render()
      @r = "R output!\n"
      @r << setup
      @r << plot
      @r << axes
      @r << done
      @r
    end

    def setup
      "file setup\n"
    end

    def plot
      params = {
        :type => 'l',
        :xlab => '',
        :ylab => '',
        :axes => false,
        :col => 'blue',
        :lwd => 5,
        :xaxs => 'i',
        :yaxs => 'i',
        :xlim => [@chart[:axes][0][:bottom], @chart[:axes][0][:top]],
        :ylim => [@chart[:axes][1][:bottom], @chart[:axes][1][:top]],
      }
      "plot(d, " + params.map {|k,v| rarg(k, v)}.join(",\n\t") + "\n\t)\n"
    end

    def axes
      "axis(1)\n" + "axis(2)\n"
    end
    def done
      "dev.off()\n"
    end

    protected

    def rarg(k, v)
      case v
      when true, false
        "#{k} = #{v.to_s.upcase}"
      when Numeric
        "#{k} = #{v}"
      when Array
        "#{k} = c(#{v.join(',')})"
      else
        "#{k} = '#{v}'"
      end
    end
  end # RPlotRenderer
end # Chart
