class ChangeBookingOpeningType < ActiveRecord::Migration[5.1]
  def up
    remove_column :places, :opening
    add_column :places, :opening, :datetime
  end

  def down
    remove_column :places, :opening
    add_column :places, :opening, :time
  end
end
