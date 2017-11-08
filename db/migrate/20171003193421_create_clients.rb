class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :rut
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :city
      t.string :phone
      t.string :car_license
      t.string :car_brand
      t.string :car_model
      t.string :car_color

      t.timestamps
    end
  end
end
