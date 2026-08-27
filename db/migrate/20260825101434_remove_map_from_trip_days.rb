class RemoveMapFromTripDays < ActiveRecord::Migration[8.1]
  def change
    remove_column :trip_days, :map, :string
  end
end
