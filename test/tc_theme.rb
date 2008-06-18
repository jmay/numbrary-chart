require File.dirname(__FILE__) + '/test_helper'

class TestTheme < Test::Unit::TestCase
  def test_new
    theme = Chart::Theme::Default.new
    assert_equal(800, theme.canvas[:width])
    assert_equal(400, theme.canvas[:height])
  end
end