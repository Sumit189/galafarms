class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  def add_product(product, qty)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity = current_item.quantity + qty.to_i
    else
      current_item = line_items.build(product_id: product.id, cart_id: id, quantity: qty)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

end
