class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.bigint :cart_id
      t.bigint :customer_id
      t.bigint :amount
      t.bigint :address_id
      t.string :transaction_id

      t.timestamps
    end
  end
end
