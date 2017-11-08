class AddDisplayOrderToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :display_order, :integer
  end
end
