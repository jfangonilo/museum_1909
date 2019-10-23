class Patron
  attr_reader :name, :spending_money, :interests

  def initialize(name, spending_money)
    @name  = name
    @spending_money = spending_money
    @interests = []
  end

  def add_interest(topic)
    @interests << topic
  end

  def spend_money(amount)
    (@spending_money -= amount) unless amount > spending_money
  end

  def attend_exhibit(exhibit)
    spend_money(exhibit.cost) unless exhibit.cost > spending_money
  end
end
