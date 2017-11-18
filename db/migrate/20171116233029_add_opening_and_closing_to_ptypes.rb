class AddOpeningAndClosingToPtypes < ActiveRecord::Migration[5.1]
  def change
    add_column :ptypes, :opening, :datetime
    add_column :ptypes, :closing, :datetime
  end
end
