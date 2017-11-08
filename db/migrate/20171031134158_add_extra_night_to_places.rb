class AddExtraNightToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :extra_night, :integer
  end
end
