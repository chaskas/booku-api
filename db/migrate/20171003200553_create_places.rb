class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name
      t.references :ptype, foreign_key: true
      t.integer :capacity
      t.integer :price
      t.time :opening
      t.datetime :closing

      t.timestamps
    end
  end
end
