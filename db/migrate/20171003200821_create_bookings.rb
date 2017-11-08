class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.datetime :arrival
      t.datetime :departure
      t.integer :price
      t.integer :discount
      t.integer :status
      t.integer :adults
      t.integer :childrens
      t.references :client, foreign_key: true
      t.references :place, foreign_key: true

      t.timestamps
    end
  end
end
