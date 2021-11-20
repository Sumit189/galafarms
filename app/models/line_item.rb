class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    self.product.price.to_i * self.quantity.to_i
  end
end
