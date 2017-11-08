class CreateStatements < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.references :booking, foreign_key: true
      t.references :status, foreign_key: true
    end
  end
end
