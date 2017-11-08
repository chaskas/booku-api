class AddPluralToPtype < ActiveRecord::Migration[5.1]
  def change
    add_column :ptypes, :plural, :string
  end
end
