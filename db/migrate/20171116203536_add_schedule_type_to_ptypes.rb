class AddScheduleTypeToPtypes < ActiveRecord::Migration[5.1]
  def change
    add_column :ptypes, :schedule_type, :integer, :default => 0
  end
end
