class ChangeBookingsPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :total, :integer
    rename_column :bookings, :price, :subtotal
  end
end
