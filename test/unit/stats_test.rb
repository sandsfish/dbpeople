require 'test_helper'

class StatsTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Stats.new.valid?
  end
end
