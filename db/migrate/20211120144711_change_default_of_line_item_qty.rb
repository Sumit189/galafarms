class ChangeDefaultOfLineItemQty < ActiveRecord::Migration[6.1]
  def change
    change_column_default :line_items, :quantity, 0
  end
end
