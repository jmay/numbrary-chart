require 'tempfile'

module Chart
  class PloticusBarGIFRenderer
    def render(chart)
      tempfile
      emit_getdata(chart)
      emit_areadef(chart)
      emit_barsdef(chart)
      r = generate
      # launch pl
      # suck in the output PNG file
      # (optionally) clean up the .pls and output files
      # construct & return Rendering object
      cleanup
      r
    end

    # create temporary .pls file
    def tempfile
      @tmpfile = Tempfile.new("plot")
    end

    def cleanup
      # puts `cat #{@tmpfile.path}`
      File.unlink(@tmpfile.path)
    end

    # write out Ploticus getdata section
    def emit_getdata(chart)
      @tmpfile << "#proc getdata\ndata:\n"
      chart.dataset.series.first.data.each do |e|
#         @tmpfile << e[:chron].value << "\t" << e[:measure].value << "\n"
        @tmpfile << e[:chron].value << "\t" << e[:measure] << "\n"
      end
      @tmpfile << "\nfieldnames: chron measure\n\n"
    end

    # write out Ploticus areadef section (canvas & axes)
    def emit_areadef(chart)
      @tmpfile << <<_EOT_
#proc areadef
rectangle: 2 2 8 5

xscaletype: linear
xrange: #{chart.chron_axis.bottom} #{chart.chron_axis.top}
xaxis.label: Year
xaxis.labeldetails: 
xaxis.stubs: inc #{chart.chron_axis.interval_size}
xaxis.stubrange: #{chart.chron_axis.min} #{chart.chron_axis.max}
xaxis.tics: none

yrange: #{chart.yaxis.bottom} #{chart.yaxis.top}
yaxis.label: #{chart.canvas.title}
yaxis.selflocatingstubs: text
#{chart.yaxis.ticks.map {|t| "#{t.position} #{t.label}"}.join("\n")}

yaxis.stubdetails: adjust=0.1,0
yaxis.tics: none
yaxis.axisline: color=gray(0.8)
yaxis.grid: color=gray(0.8)

_EOT_
    end

    # write out Ploticus areadef section (instructions for laying out the data)
    def emit_barsdef(chart)
      @tmpfile << <<_EOT_
#proc bars
locfield: chron
lenfield: measure
barwidth: 0.25
outline: no
crossover: 0
_EOT_
    end

    def generate
      @tmpfile.close
      # system "#{ENV['HOME']}/Projects/Asqwer/Ploticus/bin/pl -debug -gif -o /tmp/plot.gif #{@tmpfile.path}"
      system "#{ENV['HOME']}/Projects/Asqwer/Ploticus/bin/pl -gif -o /tmp/plot.gif #{@tmpfile.path}"
      # puts "Wrote graphic for #{$$} to /tmp/plot.gif"
      raw = IO.read("/tmp/plot.gif")
      # File.unlink "/tmp/plot.out"
      Rendering.new(raw, "image/gif")
    end
  end

  # this is the result of a rendering
  # contains the binary lump, plus MIME information, and anything else:
  # imagemap (if appropriate)
  class Rendering
    attr_reader :raw, :mimetype

    def initialize(raw, mimetype)
      @raw = raw
      @mimetype = mimetype
    end
  end
end
