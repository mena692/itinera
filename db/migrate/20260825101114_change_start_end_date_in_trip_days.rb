class ChangeStartEndDateInTripDays < ActiveRecord::Migration[8.1]
  def change
    remove_column :trip_days, :start_date, :date
    remove_column :trip_days, :end_date, :date
    add_column :trip_days, :date, :date
  end
end
