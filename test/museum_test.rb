require'./lib/exhibit'
require'./lib/patron'
require'./lib/museum'
require 'minitest/pride'
require 'minitest/autorun'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @imax = Exhibit.new("IMAX", 15)

    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_without_exhibits
    assert_equal [], @dmns.exhibits
  end

  def test_it_can_gain_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    assert_equal [@gems_and_minerals], @dmns.exhibits
    @dmns.add_exhibit(@dead_sea_scrolls)
    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.exhibits
    @dmns.add_exhibit(@imax)
    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_recommend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("IMAX")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@bob)
    assert_equal [@imax], @dmns.recommend_exhibits(@sally)
  end

  def test_it_starts_without_patrons
    assert_equal [], @dmns.patrons
  end

  def test_it_can_admit_patrons
    @dmns.admit(@bob)
    assert_equal [@bob], @dmns.patrons
    @dmns.admit(@sally)
    assert_equal [@bob, @sally], @dmns.patrons
  end

  def test_patrons_by_exhibit
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = {
      @gems_and_minerals => [@bob],
      @dead_sea_scrolls => [@bob, @sally],
      @imax => []
    }
    assert_equal expected, @dmns.patrons_by_interest
  end

  def test_interested_patrons
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)
    assert_equal [@bob, @sally], @dmns.interested_patrons(@dead_sea_scrolls)
    assert_equal [@bob], @dmns.interested_patrons(@gems_and_minerals)
    assert_equal [], @dmns.interested_patrons(@imax)
  end

  def test_revenue_starts_zero
    assert_equal 0, @dmns.revenue
  end

  def test_patrons_spend_money_accordingly
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX") #15
    tj.add_interest("Dead Sea Scrolls") #10
    @dmns.admit(tj)
    assert_equal 7, tj.spending_money
    # patron doesn't have money to attend anything

    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls") #10
    bob.add_interest("IMAX") #15
    @dmns.admit(bob)
    assert_equal 0, bob.spending_money
    # patron only attends dead sea scrolls

    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX") #15
    sally.add_interest("Dead Sea Scrolls") #10
    @dmns.admit(sally)
    assert_equal 5, sally.spending_money
    # patron only attends imax

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals") #0
    morgan.add_interest("Dead Sea Scrolls") #10
    @dmns.admit(morgan)
    assert_equal 5, morgan.spending_money
    # patron attends both
  end
end
