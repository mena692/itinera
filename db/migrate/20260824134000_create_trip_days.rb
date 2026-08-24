class CreateTripDays < ActiveRecord::Migration[8.1]
  def change
    create_table :trip_days do |t|
      t.string :name
      t.text :description
      t.references :trip, null: false, foreign_key: true
      t.string :map
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
