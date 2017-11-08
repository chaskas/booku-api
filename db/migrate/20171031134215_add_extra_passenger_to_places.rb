class AddExtraPassengerToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :extra_passenger, :integer
  end
end
