class AddNotesToBooking < ActiveRecord::Migration[5.1]
  def up
    add_column :bookings, :notes, :string
  end
  def down
    remove_column :bookings, :notes
  end
end
