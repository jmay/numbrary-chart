require File.dirname(__FILE__) + '/test_helper'

class TestAxis < Test::Unit::TestCase
  def test_attrs
    axis = Chart::Axis.new
    axis.add_data(1,4,7,3,16,5)
    assert_equal(16, axis.max)
    assert_equal(1, axis.min)
    assert_not_nil(axis.top)
    assert_not_nil(axis.bottom)
    assert_not_nil(axis.interval_size)
    assert_not_nil(axis.nticks)
    # assert(axis.calculate == 2, "Failure message [#{axis.calculate}].")
  end

  def test_flatten
    axis = Chart::Axis.new([2,6,8], [1,5])
    assert_equal(8, axis.max)
    assert_equal(1, axis.min)
    axis = Chart::Axis.new([[2,6,8, 1,5]])
    assert_equal(8, axis.max)
    assert_equal(1, axis.min)
  end

  def test_oom
    assert_equal(8.0.order_of_magnitude, 1)
    assert_equal(500.0.order_of_magnitude, 3)
    assert_equal(2652842.0.order_of_magnitude, 7)
    assert_equal(924.25725.order_of_magnitude, 3)
    assert_equal(1.0.order_of_magnitude, 1)
    assert_equal(0.99999.order_of_magnitude, 0)
  end

  def test_upto
    a = []
    3.0.upto(7.0) {|n| a << n}
    assert_equal([3.0, 4.0, 5.0, 6.0, 7.0], a)
    b = []
    3.0.upto(18.0, :by => 2.5) {|n| b << n}
    assert_equal([3.0, 5.5, 8.0, 10.5, 13.0, 15.5, 18.0], b)
  end

  def test_reduce_interval
    assert_equal(200.0, 500.0.reduce_interval)
    assert_equal(100.0, 200.0.reduce_interval)
    assert_equal(50.0, 100.0.reduce_interval)
    assert_equal(0.05, 0.1.reduce_interval)
  end

  def test_rounding
    assert(10.0.round_up(10) == 10, "round up 10 by 10s => 10")
    assert(10.0.round_down(10) == 10, "round down 10 by 10s => 10")
    assert(11.0.round_up(10) == 20, "round up 11 by 10s => 20")
    assert(11.0.round_down(10) == 10, "round down 11 by 10s => 10")
    assert(1.0.round_up(1000) == 1000, "round up 1 by 1000s => 1000")
    assert(1.0.round_down(1000) == 0, "round down 1 by 1000s => 0")
    assert(-47.0.round_down(20) == -60, "round down -47 by 20s => -60")
  end
  
  def test_appends
    axis = Chart::Axis.new
    axis.add_data(1,2,3,4,5)
    assert_equal(5, axis.max)
    assert_equal(1, axis.min)
    axis.add_data(6)
    assert_equal(6, axis.max)
    assert_equal(1, axis.min)
    axis.add_data(0, 4)
    assert_equal(6, axis.max)
    assert_equal(0, axis.min)
  end

  def test_include_zero
    axis = Chart::Axis.new
    axis.add_data(2,4,3,5,1)
    assert_equal(5, axis.max)
    assert_equal(1, axis.min)
    axis.add_data(0)
    assert_equal(5, axis.max)
    assert_equal(0, axis.min)
  end

  def test_intervals
    axis = Chart::Axis.new(2,4,3,5,1)
    assert_equal(1.0, axis.starting_interval_size)
  end

  def test_nticks
    axis = Chart::Axis.new(2,4,3,5,1,6)
    assert_equal(6, axis.nticks)
    assert_equal(1.0, axis.interval_size)
    axis.add_data(11)
    assert_equal(7, axis.nticks)
    assert_equal(2.0, axis.interval_size)
    axis.add_data(20)
    assert_equal(5, axis.nticks)
    assert_equal(5.0, axis.interval_size)
  end

  def test_max_intvls
    axis = Chart::Axis.new(2,4,3,5,1)
    assert_equal(10, axis.maximum_intervals)
    axis.maximum_intervals = 20
    assert_equal(20, axis.maximum_intervals)
    axis.maximum_intervals = 5
    assert_equal(5, axis.maximum_intervals)
  end
  
  def test_length
    axis = Chart::Axis.new(2,4,3,5,1,6)
    assert_equal(5, axis.length)
  end
  
  def test_big_numbers
    axis = Chart::Axis.new(1253116,1324310,1381614,1409487,1461855,1515821,1560535,1601227,1652598,1701913,1789067,1863033,2010972,2159917)
    assert_equal(100000, axis.interval_size)
  end

  def test_flat_axis
    axis = Chart::Axis.new(100,100,100,100)
    assert_equal(100, axis.min)
    assert_equal(100, axis.max)
    assert_equal(100, axis.bottom)
    assert_equal(100, axis.top)
  end
end
