module ApplicationHelper
  def format_price(price)
    number_to_currency(price, precision: 2)
  end
end
