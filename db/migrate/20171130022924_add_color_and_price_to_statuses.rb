class AddColorAndPriceToStatuses < ActiveRecord::Migration[5.1]
  def up
    add_column :statuses, :color, :string
    add_column :statuses, :price, :integer, :default => 0
  end
  def down
    remove_column :statuses, :color
    remove_column :statuses, :price
  end
end
