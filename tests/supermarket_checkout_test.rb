require_relative '../src/supermarket_checkout'

require 'rubygems'
require 'test/unit'


class SupermarketCheckoutTest < Test::Unit::TestCase
  def get_rules
    rules = Rules.new
    rules.add(Rule.new(:A, 50).add_special_price(3, 130))
    rules.add(Rule.new(:B, 30).add_special_price(2, 45))
    rules.add(Rule.new(:C, 20))
    rules.add(Rule.new(:D, 15))

    rules
  end

  def total(items)
    supermarket_checkout = SupermarketCheckout.new(get_rules)

    items.split(//).each { |item| supermarket_checkout.scan(item) }

    supermarket_checkout.total
  end

  def test_scan_singleItemA_returnItemAPrice
    price = total("A")

    assert_equal 50, price
  end

  def test_scan_singleItemB_returnItemBPrice
    price = total("B")

    assert_equal 30, price
  end

  def test_scan_singleItemC_returnItemCPrice
    price = total("C")

    assert_equal 20, price
  end

  def test_scan_singleItemD_returnItemDPrice
    price = total("D")

    assert_equal 15, price
  end

  def test_scan_twoItemsWithoutSpecialPrice_returnTotalPrice
    price = total("AB")

    assert_equal 80, price
  end

  def test_scan_twoItemsWithoutSpecialPrice_returnTotalPrice2
    price = total("CD")

    assert_equal 35, price
  end

  def test_scan_threeItemsWithoutSpecialPrice_returnTotalPrice2
    price = total("ABC")

    assert_equal 100, price
  end

  def test_scan_twoSameItemsBWithSpecialPrice_returnSpecialPriceForItemB
    price = total("BB")

    assert_equal 45, price
  end

  def test_scan_threeSameItemsAWithSpecialPrice_returnSpecialPriceForItemA
    price = total("AAA")

    assert_equal 130, price
  end
end