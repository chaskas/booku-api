class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :method
      t.integer :bill
      t.references :booking, foreign_key: true

      t.timestamps
    end
  end
end
