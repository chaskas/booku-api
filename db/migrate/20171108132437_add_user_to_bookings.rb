class AddUserToBookings < ActiveRecord::Migration[5.1]
  def change
    add_reference :bookings, :user, foreign_key: true, :default => 0
  end
end
