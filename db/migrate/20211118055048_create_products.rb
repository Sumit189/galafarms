class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :product_name
      t.string :product_type
      t.string :product_brand
      t.string :description
      t.float :price

      t.timestamps
    end
  end
end
