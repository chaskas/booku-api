class AddDepartureScheduleExtensionToPlaces < ActiveRecord::Migration[5.1]
  def change
    # departure schedule extension price
    add_column :places, :dsep, :integer
  end
end
