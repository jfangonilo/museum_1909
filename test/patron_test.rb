require'./lib/patron'
require 'minitest/pride'
require 'minitest/autorun'

class PatronTest < Minitest::Test
  def setup
    @bob = Patron.new("Bob", 20)
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
end
