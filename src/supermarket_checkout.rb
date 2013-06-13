class SupermarketCheckout

  def initialize(rules)
    @rules = rules
    @total = 0
    @items_list = Hash.new(0)
  end

  def scan(item)
    item_symbol = item.to_sym

    @items_list[item_symbol] += 1
  end

  def total
    @items_list.each_pair do |item, items_count|
      @total += @rules.bill_for(item, items_count)
    end

    @total
  end
end

class Rule
  attr_reader :item
  attr_reader :price
  attr_reader :items_count
  attr_reader :special_price

  def initialize(item, price)
    @item = item
    @price = price
    @has_special_price = false
  end

  def add_special_price(items_count, special_price)
    @has_special_price = true

    @items_count = items_count
    @special_price = special_price

    self
  end

  def has_special_price?
    @has_special_price
  end
end

class Rules
  def initialize
    @rules = Array.new
  end

  def add(rule)
    @rules << rule
  end

  def bill_for(item, item_count)
    item_rule = get_item_rule(item)

    if !item_rule.has_special_price?
      return item_count * item_rule.price
    end

    items_with_out_discount = item_count % item_rule.items_count
    items_with_out_discount_price = items_with_out_discount * item_rule.price

    items_with_discount = item_count - items_with_out_discount
    items_with_discount_price = (items_with_discount / item_rule.items_count) * item_rule.special_price

    items_with_out_discount_price + items_with_discount_price
  end

  private

  def get_item_rule(item)
    @rules.find { |rule| rule.item.equal?(item) }
  end
end