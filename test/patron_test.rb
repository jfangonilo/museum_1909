require'./lib/patron'
require'./lib/exhibit'
require 'minitest/pride'
require 'minitest/autorun'

class PatronTest < Minitest::Test
  def setup
    @bob = Patron.new("Bob", 20)

    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @imax = Exhibit.new("IMAX", 15)
  end

  def test_it_exists
    assert_instance_of Patron, @bob
  end

  def test_it_has_attributes
    assert_equal "Bob", @bob.name
    assert_equal 20, @bob.spending_money
  end

  def test_it_doesnt_start_with_interests
    assert_equal [], @bob.interests
  end

  def test_it_can_gain_interests
    @bob.add_interest("Dead Sea Scrolls")
    assert_equal ["Dead Sea Scrolls"], @bob.interests
    @bob.add_interest("Gems and Minerals")
    assert_equal ["Dead Sea Scrolls", "Gems and Minerals"], @bob.interests
  end

  def test_spend_money
    @bob.spend_money(10)
    assert_equal 10, @bob.spending_money
    @bob.spend_money(15)
    assert_equal 10, @bob.spending_money
  end

  def test_attend_exhibit
    @bob.attend_exhibit(@imax)
    assert_equal 5, @bob.spending_money
    @bob.attend_exhibit(@gems_and_minerals)
    assert_equal 5, @bob.spending_money
  end
end
