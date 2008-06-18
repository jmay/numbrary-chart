module Chart
  class Axis
    attr_reader :max, :min, :top, :bottom, :maximum_intervals, :interval_size, :elements
    attr_accessor :min_interval_size

    def initialize(*ary)
      @maximum_intervals = 10
      @elements = []
      @min_interval_size = 0
      add_data(*ary) unless ary.empty?
    end

    def maximum_intervals=(nintervals)
      @maximum_intervals = nintervals
      calculate
    end

    def interval_size=(new_interval)
      @interval_size = new_interval.to_f
      @top = max.round_up(@interval_size)
      @bottom = min.round_down(@interval_size)
    end

    def add_data(*ary)
      @elements += ary.flatten
      @max = @elements.max.to_f
      @min = @elements.min.to_f
      calculate
    end

    def include_zero
      add_data(0)
    end

    def nticks
      ((@top - @bottom) / @interval_size).ceil + 1
    end

    def calculate
      if @max == @min
        @interval_size = 0
        @top = max
        @bottom = min
        return
      end

      self.interval_size = last_interval_size = starting_interval_size
      until (nticks > @maximum_intervals or @interval_size < @min_interval_size)
        last_interval_size = interval_size
        self.interval_size = @interval_size.reduce_interval
      end
      self.interval_size = last_interval_size
    end

    # (80-70)/10 = 1; 1.oom = 1; start with interval = 10^1 = 10
    # (800-350)/10 = 45; 45.oom = 2; start with interval = 10^2 = 100
    def starting_interval_size
      (10 ** ((@max - @min) / @maximum_intervals).order_of_magnitude)
    end

    def length
      top - bottom
    end
  end
end

class Float
  def round_up(interval)
    (self/interval).ceil * interval
  end

  def round_down(interval)
    (self/interval).floor * interval
  end

  def order_of_magnitude
    Math::log10(self.abs).floor + 1
  end

  def reduce_interval
    oom = self.order_of_magnitude - 1
    case (self.to_f / 10**oom)
      when 5: 2 * 10**oom
      when 2: 1 * 10**oom
      when 1: 5 * 10**(oom-1)
    end
  end

  def upto(high, opts = {})
    n = self
    step = opts[:by] || 1.0
    while n < high - 0.0001   # need this adjustment because these are floats
      yield n
      n += step
    end
    # include the overshoot value, so that the high value is guaranteed to be <= the last tick
    yield n
  end
  
  def commas
    self.to_i.to_s.gsub(/(\d)(?=\d{3}+(\.\d*)?$)/, '\1,')
    # x.to_s.reverse.gsub(/([0-9]{3})/,"\\1,").gsub(/,$/,"").reverse
    # x.to_s.gsub(/(\d)(?=\d{3}+$)/, '\1,')
    # x.to_s.gsub(/(\d)(?=\d{3}+(\.\d*)?$)/, '\1,')
    # x.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
  end
end
