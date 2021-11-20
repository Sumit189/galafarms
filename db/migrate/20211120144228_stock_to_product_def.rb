class StockToProductDef < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :stock, 1
  end
end
