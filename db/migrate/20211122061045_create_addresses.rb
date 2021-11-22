class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.bigint :zip
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
