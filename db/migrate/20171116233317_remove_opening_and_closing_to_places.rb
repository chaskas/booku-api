class RemoveOpeningAndClosingToPlaces < ActiveRecord::Migration[5.1]
  def up
    remove_column :places, :opening
    remove_column :places, :closing
  end
  def down
    add_column :places, :opening, :datetime
    add_column :places, :closing, :datetime
  end
end
